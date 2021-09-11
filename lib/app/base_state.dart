import 'dart:async';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/events/system_events.dart';
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
import 'package:applithium_core/services/localization/delegate.dart';
import 'package:applithium_core/services/localization/extensions.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class AplAppState<W extends StatefulWidget> extends State<W> {
  final String title;
  @protected
  late Store globalStore;
  final AplConfig defaultConfig;
  final Widget Function(BuildContext) splashBuilder;
  final Set<AplModule> modules;
  final List<RouteDetails> routes;
  final NavigatorObserver? navObserver;
  final Future<String?> Function() _initialLinkProvider;
  final Locale? locale;

  AplAppState(
      {String? title,
      this.navObserver,
      required this.defaultConfig,
      required this.splashBuilder,
      Future<String?> Function()? initialLinkProvider,
      Set<Analyst>? analysts,
      required this.routes,
      this.locale,
      this.modules = const {}})
      : this.title = title ?? "Applithium Based Application",
        _initialLinkProvider = initialLinkProvider ?? getInitialLink;

  @override
  initState() {
    Fimber.plantTree(DebugTree());
    log("initState");
    super.initState();
    globalStore = _buildGlobalStore(modules);
    _plantCustomLogTree();
  }

  @override
  Widget build(BuildContext context) {
    return Scope(
        parentContext: null,
        store: globalStore,
        builder: (context) => MaterialApp(
            navigatorObservers: navObserver != null ? [navObserver!] : const [],
            home: _SplashScreen<_AppInitialData>(
              builder: splashBuilder,
              configLoader: (context) async {
                final provider = globalStore.getOrNull<ConfigProvider>();
                final config = provider != null
                    ? (await provider.getApplicationConfig())
                    : defaultConfig;
                final initialLink = await _initialLinkProvider.call();
                log("initial link = $initialLink");
                return _AppInitialData(defaultConfig, config, initialLink);
              },
              nextScreenBuilder: (context, initialData) => Scope(
                  parentContext: context,
                  store: _buildAppStore(modules: modules, data: initialData),
                  builder: (context) => _RealApplication(
                      locale: locale,
                      initialData: initialData,
                      routes: routes,
                      title: title)),
            )));
  }

  @override
  void dispose() {
    _unPlantCustomLogTree();
    Fimber.unplantTree(DebugTree());
    super.dispose();
  }

  void _plantCustomLogTree() {
    final customTree = globalStore.getOrNull<LogTree>();
    if (customTree != null) {
      Fimber.plantTree(customTree);
    }
  }

  void _unPlantCustomLogTree() {
    final customTree = globalStore.getOrNull<LogTree>();
    if (customTree != null) {
      Fimber.unplantTree(customTree);
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
    log("pushReplacement");
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
    BlocSupervisor.listener = context.get<EventBus>().blocListener;
    context
        .get<EventTriggeredHandlerService>()
        .setActionHandler(_processAction);
    _setupWidgetObservers();
    _handleIncomingLinks();
    context.get<UsageHistoryService>().openSession();
  }

  @override
  Widget build(BuildContext context) {

    final localizationConfig = widget.initialData.config.localizations;
    final supportedLocales = localizationConfig.getSupportedLocaleCodes()
    .map((item) => item.toLocale()).toList();

    return MaterialApp(
      title: widget.title,
      theme: context.getOrNull(),
      navigatorKey: _navigationKey,
      initialRoute: widget.initialData.link,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: context.get<EventBus>().navigatorObservers,
      locale: widget.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: [
        AppLocalizationsDelegate(localizationConfig),
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

  void _processAction(SystemEvent action, Object? sender) async {
    logMethod("processAction", params: [action, sender]);
    switch (action.type) {
      case AplActionType.ROUTE:
        _router.applyRoute(action.path);
        break;
      case AplActionType.SHOW_DIALOG:
        if (sender != null) {
          final senderBloc = sender as AplBloc;
          // senderBloc.showDialog(action.path);
        }
        break;
      case AplActionType.SHOW_TOAST:
        if (sender != null) {
          final senderBloc = sender as AplBloc;
          // senderBloc.showToast(action.path);
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

Store _buildGlobalStore(Set<AplModule> modules) {
  final result = Store()..add((provider) => SharedPreferences.getInstance());
  modules.forEach((module) => module.injectToGlobal(result));
  return result;
}

Store _buildAppStore(
    {required Set<AplModule> modules, required _AppInitialData data}) {
  final store = Store()
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

  modules.forEach((module) => module.injectToApp(store));

  return store;
}
