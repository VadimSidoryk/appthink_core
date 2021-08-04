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
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class AplAppState<W extends StatefulWidget> extends State<W> {
  static Store _buildGlobalStore(Set<AplModule> modules) {
    final result = Store()..add((provider) => SharedPreferences.getInstance());
    modules.forEach((module) => module.injectToGlobal(result));
    return result;
  }

  static Store _buildAppStore(
      {required Set<AplModule> modules, required _AppInitialData data}) {
    final store = Store()
      ..add((provider) => EventTriggeredHandlerService(provider.get()))
      ..add((provider) => AnalyticsService()..addAnalyst(LogAnalyst()))
      ..add((provider) => EventBus(listeners: {
            provider.get<AnalyticsService>(),
            TriggeredEventsHandlerAdapter(provider.get())
          }))
      ..add((provider) => ResourceService())
      ..add((provider) => data.config);

    store.add((provider) => UsageHistoryService(
        preferencesProvider: provider.get(),
        listener: SessionEventsAdapter(provider.get(), provider.get())));

    modules.forEach((module) => module.injectToApp(store));

    return store;
  }

  final String title;
  @protected
  late Store globalStore;
  final AplConfig defaultConfig;
  final Widget Function(BuildContext) splashBuilder;
  final Set<AplModule> modules;
  final List<RouteDetails> routes;

  final _routesSubj = PublishSubject<Route>();
  Stream<Route> get routesObs  => _routesSubj;

  AplAppState(
      {String? title,
      required this.defaultConfig,
      required this.splashBuilder,
      Set<Analyst>? analysts,
      required this.routes,
      this.modules = const {}})
      : this.title = title ?? "Applithium Based Application";

  @override
  initState() {
    log("initState");
    super.initState();
    globalStore = _buildGlobalStore(modules);
  }

  @override
  Widget build(BuildContext context) {
    return Scope(
        parentContext: null,
        store: globalStore,
        builder: (context) => MaterialApp(
            navigatorObservers: [_AppNavigatorObserver(_routesSubj)],
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
              nextScreenBuilder: (context, initialData) => Scope(
                  parentContext: context,
                  store: _buildAppStore(modules: modules, data: initialData),
                  builder: (context) => _RealApplication(
                      initialData: initialData, routes: routes, title: title)),
            )));
  }
}

class _AppNavigatorObserver extends NavigatorObserver {

  final Subject<Route> subject;

  _AppNavigatorObserver(this.subject);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      subject.add(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      subject.add(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      subject.add(previousRoute);
    }
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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => nextScreenBuilder(context, config)));
  }
}

class _RealApplication extends StatefulWidget {
  final _AppInitialData initialData;
  final String title;
  final List<RouteDetails> routes;

  const _RealApplication(
      {Key? key,
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
    Scope.of(context)?.store.add((provider) => _router);
    BlocSupervisor.listener = context.get<EventBus>().blocListener;
    context.get<ResourceService>()
        .init(context, widget.initialData.config.resources);
    context.get<EventTriggeredHandlerService>()
        .setActionHandler(_processAction);
    _setupWidgetObservers();
    _handleIncomingLinks();
    context.get<UsageHistoryService>().openSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: context.getOrNull(),
      navigatorKey: _navigationKey,
      initialRoute: widget.initialData.link,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: context.get<EventBus>().navigatorObservers,
    );
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

  void _setupWidgetObservers() {
    logMethod(methodName: "setupWidgetObservers");
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    _widgetObserver = context.get<UsageHistoryService>().asWidgetObserver();
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
