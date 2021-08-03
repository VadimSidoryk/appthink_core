import 'dart:async';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/events/action.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/analytics/usage_adapter.dart';
import 'package:applithium_core/services/events/analyst_adapter.dart';
import 'package:applithium_core/services/events/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core/services/resources/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class AplAppState<W extends StatefulWidget> extends State<W> {
  final String title;
  @protected
  late Store globalStore;
  final AplConfig defaultConfig;
  final Widget Function(BuildContext) splashBuilder;
  final Set<AplModule>? modules;
  final List<RouteDetails> routes;

  AplAppState(
      {String? title,
      required this.defaultConfig,
      required this.splashBuilder,
      Set<Analyst>? analysts,
      required this.routes,
      this.modules})
      : this.title = title ?? "Applithium Based Application";

  @override
  initState() {
    log("initState");
    super.initState();
    globalStore = _buildGlobalStore(modules ?? {});
  }

  static Store _buildGlobalStore(Set<AplModule> modules) {
    final result = Store()..add((provider) => SharedPreferences.getInstance());
    modules.forEach((module) => module.injectToGlobal(result));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithGlobalScope((context) => MaterialApp(
          home: _SplashScreen<_AppInitialData>(
              builder: splashBuilder,
              configLoader: (context) async {
                final provider = globalStore.getOrNull<ConfigProvider>();
                final config = provider != null
                    ? (await provider.getApplicationConfig())
                    : defaultConfig;
                final initialLink = await getInitialLink();
                return _AppInitialData(defaultConfig, config, initialLink);
              },
              nextScreenBuilder: (context, initialData) => _RealApplication(
                  initialData: initialData,
                  routes: routes,
                  title: title,
                  modules: modules ?? {})),
        ));
  }

  Widget _wrapWithGlobalScope(WidgetBuilder builder) {
    return Scope(parentContext: null, store: globalStore, builder: builder);
  }
}

class _SplashScreen<D> extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  final Widget Function(BuildContext, D) nextScreenBuilder;
  final Future<D> Function(BuildContext) configLoader;

  const _SplashScreen(
      {Key? key,
      required this.builder,
      required this.configLoader,
      required this.nextScreenBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setupInitFlow(context);
    return builder.call(context);
  }

  Future<void> _setupInitFlow(BuildContext context) async {
    final config = await configLoader.call(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => nextScreenBuilder(context, config)));
  }
}

class _RealApplication extends StatefulWidget {
  final _AppInitialData initialData;
  final String title;
  final List<RouteDetails> routes;
  final Set<AplModule> modules;

  const _RealApplication(
      {Key? key,
      required this.modules,
      required this.title,
      required this.initialData,
      required this.routes})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RealApplicationState();
  }
}

class _RealApplicationState extends State<_RealApplication> {
  StreamSubscription? _deepLinkSubscription;

  late GlobalKey<NavigatorState> _navigationKey;
  late AplRouter _router;
  late Store _appStore;
  WidgetsBindingObserver? _widgetObserver;

  @override
  void initState() {
    super.initState();
    _navigationKey = GlobalKey<NavigatorState>();
    _router = AplRouter(navigationKey: _navigationKey, routes: widget.routes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appStore = _buildAppStore(
        context: context,
        router: _router,
        handler: _processAction,
        modules: widget.modules,
        config: widget.initialData.config);

   // _setupWidgetObservers();
    _handleIncomingLinks();

    BlocSupervisor.listener = _appStore.get<EventBus>().blocListener;
    // _appStore.get<UsageHistoryService>().openSession();
    _appStore
        .get<ResourceService>()
        .init(context, widget.initialData.config.resources);
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithAppStore(
        context,
        (context) => MaterialApp(
              title: widget.title,
              theme: context.getOrNull(),
              navigatorKey: _navigationKey,
              initialRoute: widget.initialData.link,
              onGenerateRoute: _router.onGenerateRoute,
              navigatorObservers: _appStore.get<EventBus>().navigatorObservers,
            ));
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    super.dispose();
  }

  Widget _wrapWithAppStore(BuildContext parentContext, WidgetBuilder builder) {
    return Scope(
      parentContext: parentContext,
      store: _appStore,
      builder: builder,
    );
  }

  void _setupWidgetObservers() {
    logMethod(methodName: "setupWidgetObservers");
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    _widgetObserver = _appStore.get<UsageHistoryService>().asWidgetObserver();
    WidgetsBinding.instance?.addObserver(_widgetObserver!);
  }

  void _handleIncomingLinks() {
    logMethod(methodName: "handleIncomingLinks");
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _deepLinkSubscription = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      if (uri != null) {
        log("handling initial link = $uri");
        _router.applyRoute(uri.toString());
      } else {
        logError("incoming uri is null");
      }
    }, onError: (Object err) {
      if (!mounted) return;
      logError(err);
    });
  }

  static Store _buildAppStore(
      {required BuildContext context,
      required AplRouter router,
      required ActionHandler handler,
      required Set<AplModule> modules,
      required AplConfig config}) {
    final store = Store()
      ..add((provider) => router)
      ..add((provider) => EventTriggeredHandlerService(provider.get(), handler))
      ..add((provider) => AnalyticsService()..addAnalyst(LogAnalyst()))
      ..add((provider) => EventBus(listeners: {
            provider.get<AnalyticsService>(),
            TriggeredEventsHandlerAdapter(provider.get())
          }))
      ..add((provider) => ResourceService())
      ..add((provider) => config);

    modules.forEach((module) => module.injectToApp(store));

    store.add((provider) => UsageHistoryService(
        preferencesProvider: provider.get(),
        listener: SessionEventsAdapter(provider.get(), provider.get())));

    return store;
  }

  void _processAction(AplAction action, Object? sender) async {
    logMethod(methodName: "processAction", params: [action, sender]);
    switch (action.type) {
      case AplActionType.ROUTE:
        _router.applyRoute(action.path);
        break;
      case AplActionType.SHOW_DIALOG:
        if (sender != null) {
          final senderBloc = sender as BaseBloc;
          senderBloc.showDialog(action.path);
        }
        break;
      case AplActionType.SHOW_TOAST:
        if (sender != null) {
          final senderBloc = sender as BaseBloc;
          senderBloc.showToast(action.path);
        }
        break;
      default:
        break;
    }
  }
}

class _AppInitialData {
  final AplConfig defaultConfig;
  final AplConfig config;
  final String? link;

  _AppInitialData(this.defaultConfig, this.config, this.link);
}
