import 'dart:async';
import 'dart:developer';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/module/default.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core/services/localization/delegate.dart';
import 'package:applithium_core/services/localization/service.dart';
import 'package:applithium_core/services/promo/action.dart';
import 'package:applithium_core/services/promo/service.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'services/service_base.dart';

class AplAppState<W extends StatefulWidget> extends State<W> {
  final String title;
  final AplConfig defaultConfig;
  final WidgetBuilder splashBuilder;
  final PageRoute Function(WidgetBuilder) _splashRouteBuilder;
  final Set<AplService>? services;
  final Set<AplModule> modules;
  final List<RouteDetails> routes;
  final NavigatorObserver? navObserver;
  final Future<String?> Function() _initialLinkProvider;
  final Locale? locale;
  final ThemeData? themeData;

  final _debugTree = DebugTree();

  AplAppState(
      {String? title,
      this.navObserver,
      required this.defaultConfig,
      required this.splashBuilder,
      PageRoute Function(WidgetBuilder)? splashRouteBuilder,
      Future<String?> Function()? initialLinkProvider,
      required this.routes,
      this.locale,
      this.themeData,
      this.services,
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
        theme: this.themeData,
        navigatorObservers: navObserver != null ? [navObserver!] : const [],
        home: _SplashScreen<_AppInitialData>(
          builder: splashBuilder,
          routeBuilder: _splashRouteBuilder,
          loadingTask: (context) async {
            final store = await _buildStoreWithConfigProvider(modules);
            _plantCustomLogTree(store);
            final provider = store.getOrNull<ConfigProvider>();
            final config = provider != null
                ? (await provider.getApplicationConfig())
                : defaultConfig;
            await _injectDependenciesInStore(store, config);
            final initialLink = await _initialLinkProvider.call();
            log("initial link = $initialLink");
            return _AppInitialData(store, config, initialLink);
          },
          nextScreenBuilder: (context, initialData) => Scope(
              parentContext: context,
              store: initialData.store,
              builder: (context) => _RealApplication(
                themeData: themeData,
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

  Future<Store> _buildStoreWithConfigProvider(Set<AplModule> modules) async {
    final result = Store();
    bool isConfigAdded = false;
    for (final module in modules) {
      final isConfigAddedByModule = await module.injectConfigProvider(result);
      if (isConfigAddedByModule && isConfigAdded) {
        logError("ConfigProvider by module $module overrides previous one");
      }
      isConfigAdded |= isConfigAddedByModule;
    }

    if (!isConfigAdded) {
      logError("ConfigProvider wasn't added");
    }
    return result;
  }

  Future<void> _injectDependenciesInStore(Store store, AplConfig config) async {
    store.add((provider) => SharedPreferences.getInstance());
    store.add((provider) => EventBus());
    store.add((provider) => config);

    await DefaultModule(services: services).injectDependencies(store, config);
    await Future.wait(
        modules.map((module) => module.injectDependencies(store, config)));
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
  final ThemeData? themeData;
  final _AppInitialData initialData;
  final String title;
  final List<RouteDetails> routes;
  final Locale? locale;

  const _RealApplication(
      {Key? key,
      this.themeData,
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
    final promoService = context.getOrNull<PromoService>();
    if (promoService != null) {
      promoService.setActionHandler(_onPromoAction);
    }
    _setupWidgetObservers();
    _handleIncomingLinks();
    context.getOrNull<UsageHistoryService>()?.openSession();
  }

  void _onPromoAction(PromoAction action, Object? sender) {
    log("_processAction");
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = context.getOrNull<LocalizationService>();

    return MaterialApp(
      title: widget.title,
      theme: widget.themeData,
      navigatorKey: _navigationKey,
      initialRoute: widget.initialData.link,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: context.get<EventBus>().navigatorObservers,
      locale: widget.locale,
      supportedLocales: localizationService?.supportedLocales ??
          const <Locale>[Locale('en', 'US')],
      localizationsDelegates: localizationService != null
          ? [
              AppLocalizationsDelegate(context.get<LocalizationBuilder>()),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ]
          : [],
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
    final historyService = context.getOrNull<UsageHistoryService>();
    if (historyService != null) {
      _widgetObserver = historyService.asWidgetObserver();
      WidgetsBinding.instance?.addObserver(_widgetObserver!);
    }
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
  final Store store;
  final AplConfig config;
  final String? link;

  _AppInitialData(this.store, this.config, this.link);
}
