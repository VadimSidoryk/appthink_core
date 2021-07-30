import 'dart:async';

import 'package:applithium_core/config/base.dart';
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

class ApplithiumAppState<A extends StatefulWidget> extends State<A> {
  final String title;
  @protected
  Store? globalStore;
  final ConfigProvider? configProvider;
  final Set<Analyst> analysts;
  late AplRouter _router;
  WidgetsBindingObserver? _widgetObserver;
  final Widget Function(BuildContext) splashBuilder;
  final Set<AplModule>? modules;
  final List<RouteDetails> routes;

  StreamSubscription? _deepLinkSubscription;

  ApplithiumAppState(
      {String? title,
      this.configProvider,
      required this.splashBuilder,
      Set<Analyst>? analysts,
      required this.routes,
      this.modules})
      : this.title = title ?? "Applithium Based Application",
        this.analysts =
            analysts != null ? (analysts..add(LogAnalyst())) : {LogAnalyst()};

  @override
  initState() {
    log("initState");
    super.initState();
    _initSyncComponents();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
    super.dispose();
  }

  void _initSyncComponents() {
    logMethod(methodName: "init sync components");
    globalStore = createDependencyTree();
    log("globalStore created");
    _widgetObserver =
        globalStore!.get<UsageHistoryService>().asWidgetObserver();
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.addObserver(_widgetObserver!);
    }
  }

  Future<String?> _initAsyncComponents(BuildContext context) async {
    logMethod(methodName: "initAsyncComponents");
    final ApplicationConfig? config =
        await configProvider?.getApplicationConfig();
    if (config != null) {
      log("config received");
      globalStore?.add((provider) => config);
      // _router.routes = RoutesBuilder.fromPresentationsMap(
      //     context.get(), layoutBuilder, config.presentations);
      initServices(context, config);
      log("services initialized");
    }
    final initialLink = await getInitialLink();
    log("initial deepLink = $initialLink");
    return initialLink;
  }

  void _handleIncomingLinks() {
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

  @protected
  Widget buildApp(BuildContext context, String? initialLink) {
    logMethod(methodName: "buildApp");
    final navigationKey = GlobalKey<NavigatorState>();
    _router = AplRouter(navigationKey: navigationKey, routes: this.routes);

    return MaterialApp(
      title: title,
      theme: context.getOrNull(),
      navigatorKey: navigationKey,
      initialRoute: initialLink,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers: globalStore!.get<EventBus>().navigatorObservers,
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocSupervisor.listener = globalStore!.get<EventBus>().blocListener;
    globalStore!.get<UsageHistoryService>().openSession();

    return _wrapWithGlobalScope(MaterialApp(
      home: _SplashScreen(
        builder: splashBuilder,
        loader: (context) => _initAsyncComponents(context),
        nextScreenBuilder: (context, initialLink) =>
            _wrapWithGlobalScope(buildApp(context, initialLink)),
      ),
    ));
  }

  @protected
  void initServices(BuildContext context, ApplicationConfig config) {
    globalStore!.get<ResourceService>().init(context, config.resources);
    modules?.forEach((module) => module.init(context, config));
  }

  Store createDependencyTree() {
    final result = Store()
      ..add((provider) => SharedPreferences.getInstance())
      ..add((provider) =>
          EventTriggeredHandlerService(provider.get(), processAction))
      ..add((provider) => AnalyticsService(analysts: analysts))
      ..add((provider) => EventBus(listeners: {
            TriggeredEventsHandlerAdapter(provider.get()),
            provider.get<AnalyticsService>()
          }))
      ..add((provider) => UsageHistoryService(
          preferencesProvider: provider.get(),
          listener: SessionEventsAdapter(provider.get(), provider.get())))
      ..add((provider) => ResourceService())
      ..add((provider) => _router);

    modules?.forEach((module) => module.addTo(result));

    return result;
  }

  void processAction(AplAction action, Object? sender) {
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
    }
  }

  Widget _wrapWithGlobalScope(Widget wrapped) {
    return Scope(store: globalStore!, child: wrapped);
  }
}

class _SplashScreen extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  final Widget Function(BuildContext, String?) nextScreenBuilder;
  final Future<String?> Function(BuildContext) loader;

  const _SplashScreen(
      {Key? key,
      required this.builder,
      required this.loader,
      required this.nextScreenBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setupInitFlow(context);
    return builder.call(context);
  }

  Future<void> _setupInitFlow(BuildContext context) async {
    final initialLink = await loader.call(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => nextScreenBuilder(context, initialLink)));
  }
}
