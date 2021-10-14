import 'dart:async';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
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
import 'package:applithium_core/services/events/action.dart';
import 'package:applithium_core/services/events/analyst_adapter.dart';
import 'package:applithium_core/services/events/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class AplAppState<W extends StatefulWidget> extends State<W> {
  final String title;
  final AplConfig defaultConfig;
  final WidgetBuilder splashBuilder;
  final PageRoute Function(WidgetBuilder) _splashRouteBuilder;
  final Set<AplModule> modules;
  final List<RouteDetails> routes;
  final NavigatorObserver? navObserver;
  final Future<String?> Function() _initialLinkProvider;
  final Locale? locale;

  final _debugTree = DebugTree();

  AplAppState(
      {String? title,
      this.navObserver,
      required this.defaultConfig,
      required this.splashBuilder,
      PageRoute Function(WidgetBuilder)? splashRouteBuilder,
      Future<String?> Function()? initialLinkProvider,
      Set<Analyst>? analysts,
      required this.routes,
      this.locale,
      this.modules = const {}})
      : this.title = title ?? "Applithium Based Application",
        _splashRouteBuilder = splashRouteBuilder ??
            ((WidgetBuilder builder) => MaterialPageRoute(builder: builder)),
        _initialLinkProvider = initialLinkProvider ?? getInitialLink;

  @override
  initState() {
    Fimber.plantTree(_debugTree);
    log("initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: navObserver != null ? [navObserver!] : const [],
        home: _SplashScreen<_AppInitialData>(
          builder: splashBuilder,
          routeBuilder: _splashRouteBuilder,
          loadingTask: (context) async {
            final globalStore = await _buildGlobalStore(modules);
            _plantCustomLogTree(globalStore);
            final provider = globalStore.getOrNull<ConfigProvider>();
            final config = provider != null
                ? (await provider.getApplicationConfig())
                : defaultConfig;
            final initialLink = await _initialLinkProvider.call();
            log("initial link = $initialLink");
            return _AppInitialData(globalStore, config, initialLink);
          },
          nextScreenBuilder: (context, initialData) => Scope(
              parentContext: context,
              store: _buildAppStore(modules: modules, data: initialData),
              builder: (context) => _RealApplication(
                  locale: locale,
                  initialData: initialData,
                  routes: routes,
                  title: title)),
        ));
  }

  @override
  void dispose() {
    Fimber.clearAll();
    super.dispose();
  }

  void _plantCustomLogTree(Store store) {
    final customTree = store.getOrNull<LogTree>();
    if (customTree != null) {
      Fimber.plantTree(customTree);
    }
  }
}

class _SplashScreen<D> extends StatelessWidget {
  final WidgetBuilder builder;
  final PageRoute Function(WidgetBuilder) routeBuilder;
  final Widget Function(BuildContext, D) nextScreenBuilder;
  final Future<D> Function(BuildContext) loadingTask;

  const _SplashScreen(
      {Key? key,
      required this.builder,
      required this.routeBuilder,
      required this.loadingTask,
      required this.nextScreenBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setupInitFlow(context);
    return builder.call(context);
  }

  Future<void> _setupInitFlow(BuildContext context) async {
    final config = await loadingTask.call(context);
    log("pushReplacement");
    Navigator.pushReplacement(context,
        routeBuilder.call((context) => nextScreenBuilder(context, config)));
  }
}

class _RealApplication extends StatefulWidget {
  final _AppInitialData initialData;
  final String title;
  final List<RouteDetails> routes;
  final Locale? locale;

  const _RealApplication(
      {Key? key,
      this.locale,
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
    context
        .get<EventTriggeredHandlerService>()
        .setActionHandler(_processAction);
    _setupWidgetObservers();
    _handleIncomingLinks();
    context.get<UsageHistoryService>().openSession();
  }

  void _processAction(SystemAction action, Object? sender) {
    log("_processAction");
  }

  @override
  Widget build(BuildContext context) {
    // final localizationConfig = widget.initialData.config.localizations;
    // final supportedLocales = localizationConfig
    //     .getSupportedLocaleCodes()
    //     .map((item) => item.toLocale())
    //     .toList();

    return MaterialApp(
      title: widget.title,
      theme: context.getOrNull(),
      navigatorKey: _navigationKey,
      initialRoute: widget.initialData.link,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: context.get<EventBus>().navigatorObservers,
      locale: widget.locale,
      // supportedLocales: supportedLocales,
      localizationsDelegates: [
        // AppLocalizationsDelegate(localizationConfig),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
    logMethod("setupWidgetObservers");
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    _widgetObserver = context.get<UsageHistoryService>().asWidgetObserver();
    WidgetsBinding.instance?.addObserver(_widgetObserver!);
  }

  void _handleIncomingLinks() {
    logMethod("handleIncomingLinks");
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
      logError("can't handle incoming link", ex: err);
    });
  }
}

class _AppInitialData {
  final Store globalStore;
  final AplConfig config;
  final String? link;

  _AppInitialData(this.globalStore, this.config, this.link);
}

Future<Store> _buildGlobalStore(Set<AplModule> modules) async {
  final result = Store()..add((provider) => SharedPreferences.getInstance());
  for (final module in modules) {
    await module.injectOnSplash(result);
  }
  return result;
}

Store _buildAppStore(
    {required Set<AplModule> modules, required _AppInitialData data}) {
  final store = Store()
    ..extend(data.globalStore)
    ..add((provider) => EventTriggeredHandlerService(provider.get()))
    ..add((provider) => AnalyticsService()..addAnalyst(LogAnalyst()))
    ..add((provider) => EventBus(listeners: {
          provider.get<AnalyticsService>(),
          TriggeredEventsHandlerAdapter(provider.get())
        }))
    ..add((provider) => data.config);

  store.add((provider) => UsageHistoryService(
      preferencesProvider: provider.get(),
      listener: SessionEventsAdapter(provider.get(), provider.get())));

  for (final module in modules) {
     module.injectOnMain(store);
  }

  return store;
}
