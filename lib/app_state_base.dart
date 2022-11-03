import 'dart:async';

import 'package:applithium_core/events/mapper/scheme.dart';
import 'package:applithium_core/events/mapper/scheme_freezed.dart';
import 'package:applithium_core/events/navigator.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/localization/extensions.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'config/model.dart';
import 'config/provider.dart';
import 'events/event_bus.dart';
import 'module.dart';
import 'router/route_details.dart';
import 'router/router.dart';
import 'scopes/scope.dart';
import 'services/analytics/analyst.dart';
import 'services/analytics/analyst_logs.dart';
import 'services/analytics/service.dart';
import 'services/analytics/session_adapter.dart';
import 'services/history/service.dart';
import 'services/localization/config.dart';
import 'services/localization/delegate.dart';
import 'services/promo/action.dart';
import 'services/promo/analyst_adapter.dart';
import 'services/promo/service.dart';

final KEY_EXTERNAL_INITIAL_LINK = "external_initial_link";

class AplAppState<W extends StatefulWidget> extends State<W> {
  final String title;
  final AplConfig defaultConfig;
  final WidgetBuilder splashBuilder;
  final PageRoute Function(WidgetBuilder) _splashRouteBuilder;
  final Future<Store> Function() _storeBuilder;
  final Future<String?> Function(Store, AplConfig) _setupFlow;
  final List<RouteDetails> routes;
  @visibleForTesting
  final NavigatorObserver? navObserver;
  final Future<String?> Function() _initialLinkProvider;
  final Widget Function(BuildContext, Widget)? wrapper;
  final Locale? locale;
  final ThemeData? theme;

  final _debugTree = DebugTree();

  AplAppState(
      {String? title,
      @visibleForTesting this.navObserver,
      this.wrapper,
      this.theme,
      required this.defaultConfig,
      required this.splashBuilder,
      PageRoute Function(WidgetBuilder)? splashRouteBuilder,
      Future<String?> Function()? initialLinkProvider,
      Set<Analyst>? analysts,
      required this.routes,
      EventsScheme? eventScheme,
      this.locale,
      Set<AplModule> modules = const {},
      Future<String?> Function(Store, AplConfig)? customSetupFlow})
      : this.title = title ?? "Sample Application",
        _splashRouteBuilder = splashRouteBuilder ??
            ((WidgetBuilder builder) => MaterialPageRoute(builder: builder)),
        _initialLinkProvider = initialLinkProvider ?? getInitialLink,
        _storeBuilder = (() async => _buildStoreWithConfigProvider(modules)),
        _setupFlow = ((Store store, AplConfig config) async {
          await _injectDependenciesInStore(
              store, config, modules, eventScheme ?? FreezedEventsScheme());

          if (customSetupFlow != null) {
            return await customSetupFlow.call(store, config);
          } else {
            return null;
          }
        });

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
        theme: theme,
        home: _SplashScreen<_AppInitialData>(
          builder: splashBuilder,
          routeBuilder: _splashRouteBuilder,
          loadingTask: (context) async {
            final store = await _storeBuilder.call();
            _plantCustomLogTree(store);
            final provider = store.getOrNull<ConfigProvider>();
            final config = provider != null
                ? (await provider.getApplicationConfig())
                : defaultConfig;
            final initialLink = await _getInitialLink(store);
            log("initial link = $initialLink");
            final linkFromSplash = await _setupFlow.call(store, config);
            return _AppInitialData(
                store, config, initialLink ?? linkFromSplash);
          },
          nextScreenBuilder: (context, initialData) => Scope(
              parentContext: context,
              store: initialData.store,
              builder: (context) => _RealApplication(
                  theme: theme,
                  locale: locale,
                  wrapper: wrapper,
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

  Future<String?> _getInitialLink(Store store) async {
    String? deepLink;
    deepLink = await getInitialLink();
    if (deepLink != null) {
      return deepLink;
    } else {
      return store.getOrNull<String?>(key: KEY_EXTERNAL_INITIAL_LINK);
    }
  }

  static Future<Store> _buildStoreWithConfigProvider(
      Set<AplModule> modules) async {
    final result = Store();
    bool isConfigAdded = false;
    for (final module in modules) {
      final isConfigAddedByModule = await module.injectConfigProvider(result);
      if (isConfigAddedByModule && isConfigAdded) {
        print("ConfigProvider by module $module overrides previous one");
      }
      isConfigAdded |= isConfigAddedByModule;
    }

    if (!isConfigAdded) {
      print("ConfigProvider wasn't added");
    }
    return result;
  }

  static Future<void> _injectDependenciesInStore(Store store, AplConfig config,
      Set<AplModule> modules, EventsScheme eventsScheme) async {
    store.add((provider) => SharedPreferences.getInstance());
    store.add((provider) => AnalyticsService()..addAnalyst(LogAnalyst()));
    store.add((provider) => PromoService(provider.get()));
    store.add((provider) => EventBus(scheme: eventsScheme, listeners: {
          provider.get<AnalyticsService>(),
          PromoEventsAdapter(provider.get())
        }));
    store.add((provider) => config);
    store.add((provider) => UsageHistoryService(
        preferencesProvider: provider.get(),
        listener: AnalyticsSessionAdapter(provider.get(), provider.get())));

    for (final module in modules) {
      await module.injectDependencies(store, config);
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
  final Widget Function(BuildContext, Widget)? wrapper;
  final _AppInitialData initialData;
  final String title;
  final List<RouteDetails> routes;
  final Locale? locale;
  final ThemeData? theme;

  const _RealApplication(
      {Key? key,
      this.locale,
      this.wrapper,
      required this.title,
      required this.initialData,
      required this.routes,
      this.theme})
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
    context.get<PromoService>().setActionHandler(_onPromoAction);
    _setupWidgetObservers();
    _handleIncomingLinks();
    context.get<UsageHistoryService>().openSession();
  }

  void _onPromoAction(PromoAction action, Object? sender) {
    log("_processAction");
  }

  @override
  Widget build(BuildContext context) {
    final localizationConfig = LocalizationConfig(<String, dynamic>{});
    final supportedLocales = localizationConfig
        .getSupportedLocaleCodes()
        .map((item) => item.toLocale())
        .toList();

    final eventBus = context.get<EventBus>();

    final appInstance = MaterialApp(
      title: widget.title,
      theme: widget.theme,
      navigatorKey: _navigationKey,
      initialRoute: widget.initialData.link,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: <NavigatorObserver>[
            NavigatorEventsObserver(eventBus)
          ] +
          eventBus.navigatorObservers,
      locale: widget.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: [
        AppLocalizationsDelegate(localizationConfig),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );

    return widget.wrapper?.call(context, appInstance) ?? appInstance;
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
    if (_widgetObserver != null) {
      WidgetsBinding.instance.removeObserver(_widgetObserver!);
    }
    super.dispose();
  }

  void _setupWidgetObservers() {
    if (_widgetObserver != null) {
      WidgetsBinding.instance.removeObserver(_widgetObserver!);
    }
    _widgetObserver = context.get<UsageHistoryService>().asWidgetObserver();
    WidgetsBinding.instance.addObserver(_widgetObserver!);
  }

  void _handleIncomingLinks() {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _deepLinkSubscription = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      if (uri != null) {
        log("handling initial link = $uri");
        _router.push(uri.toString());
      } else {
        logError("incoming uri is null");
      }
    }, onError: (Object err) {
      if (!mounted) return;
      logError("can't handle incoming link", err);
    });
  }
}

class _AppInitialData {
  final Store store;
  final AplConfig config;
  final String? link;

  _AppInitialData(this.store, this.config, this.link);
}
