import 'dart:async';

import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/config/model.dart';
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

class ApplithiumAppState<W extends StatefulWidget> extends State<W> {
  final String title;
  @protected
  late Store globalStore;
  final ConfigProvider? configProvider;
  final Widget Function(BuildContext) splashBuilder;
  final Set<AplModule>? modules;
  final List<RouteDetails> routes;

  ApplithiumAppState(
      {String? title,
      this.configProvider,
      required this.splashBuilder,
      Set<Analyst>? analysts,
      required this.routes,
      this.modules})
      : this.title = title ?? "Applithium Based Application";

  @override
  initState() {
    log("initState");
    super.initState();
    _initGlobalComponents();
  }

  void _initGlobalComponents() {
    logMethod(methodName: "init global components");
    globalStore = _buildGlobalDependencyTree();
    log("globalStore created");
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithGlobalScope(MaterialApp(
      home: _SplashScreen<_AppInitialData>(
        builder: splashBuilder,
        configLoader: (context) async {
          final config = configProvider != null
              ? (await configProvider!.getApplicationConfig())
              : ApplicationConfig.getDefault();
          final initialLink = await getInitialLink();
          return _AppInitialData(config, initialLink);
        },
        nextScreenBuilder: (context, initialData) => _wrapWithGlobalScope(
            _RealApplication(
                globalStore: globalStore,
                config: initialData.config,
                initialLink: initialData.initialLink,
                routes: routes,
                title: title,
                modules: modules ?? {})),
      ),
    ));
  }

  Store _buildGlobalDependencyTree() {
    return Store()..add((provider) => SharedPreferences.getInstance());
  }

  Widget _wrapWithGlobalScope(Widget wrapped) {
    return Scope(store: globalStore, child: wrapped);
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
  final ApplicationConfig config;
  final String title;
  final String? initialLink;
  final Store globalStore;
  final List<RouteDetails> routes;
  final Set<AplModule> modules;

  const _RealApplication(
      {Key? key,
      required this.modules,
      required this.globalStore,
      required this.title,
      required this.config,
      this.initialLink,
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
  late WidgetsBindingObserver _widgetObserver;

  @override
  void initState() {
    super.initState();
    _navigationKey = GlobalKey<NavigatorState>();
    _router = AplRouter(navigationKey: _navigationKey, routes: widget.routes);
    _buildAppDependencyTree();
    _setupWidgetObservers();
    _handleIncomingLinks();

    BlocSupervisor.listener = widget.globalStore.get<EventBus>().blocListener;
    widget.globalStore.get<UsageHistoryService>().openSession();
  }

  void _setupWidgetObservers() {
    logMethod(methodName: "setupWidgetObservers");
    _widgetObserver = widget.globalStore.get<UsageHistoryService>().asWidgetObserver();
    WidgetsBinding.instance?.addObserver(_widgetObserver);
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

  void _buildAppDependencyTree() async {
    logMethod(methodName: "init app components");

    widget.globalStore
      ..add((provider) => _router)
      ..add((provider) =>
          EventTriggeredHandlerService(provider.get(), processAction))
      ..add((provider) => AnalyticsService()..addAnalyst(LogAnalyst()))
      ..add((provider) => EventBus(listeners: {
            provider.get<AnalyticsService>(),
            TriggeredEventsHandlerAdapter(provider.get())
          }))
      ..add((provider) => UsageHistoryService(
          preferencesProvider: provider.get(),
          listener: SessionEventsAdapter(provider.get(), provider.get())))
      ..add((provider) => ResourceService())
      ..add((provider) => widget.config);

    widget.modules.forEach((module) => module.injectInTree(widget.globalStore));
    log("modules added");
  }

  void processAction(AplAction action, Object? sender) async {
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


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.globalStore
        .get<ResourceService>()
        .init(context, widget.config.resources);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: context.getOrNull(),
      navigatorKey: _navigationKey,
      initialRoute: widget.initialLink,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: context.get<EventBus>().navigatorObservers,
    );
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
    WidgetsBinding.instance?.removeObserver(_widgetObserver);
    super.dispose();
  }
}

class _AppInitialData {
  final ApplicationConfig config;
  final String? initialLink;

  _AppInitialData(this.config, this.initialLink);
}
