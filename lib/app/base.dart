import 'dart:async';

import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/router/route.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/services/resources/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:uni_links/uni_links.dart';

typedef RouterBuilder<R extends MainRouter> = R Function(
    GlobalKey<NavigatorState>);

class BaseAppState<A extends StatefulWidget, R extends MainRouter>
    extends State<A> {
  final String title;
  final _navigatorKey = GlobalKey<NavigatorState>();
  @protected
  Store? globalStore;
  final ConfigProvider? configProvider;
  final Set<Analyst> analysts;
  late MainRouter _router;
  WidgetsBindingObserver? _widgetObserver;
  final Widget Function(BuildContext) splashBuilder;
  final Set<AplModule>? modules;

  StreamSubscription? _deepLinkSubscription;

  BaseAppState(
      {String? title,
      this.configProvider,
      required RouterBuilder<R> routerBuilder,
      required this.splashBuilder,
      Set<Analyst>? analysts,
      this.modules})
      : this.title = title ?? "Applithium Based Application",
        this.analysts = analysts != null ? (analysts..add(LogAnalyst())) : {LogAnalyst()} {
    _router = routerBuilder.call(_navigatorKey);
  }

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
    final AplConfig? config = await configProvider?.call();
    if (config != null) {
      log("config received");
      initServices(context, config);
      log("services initialized");
    }
    return getInitialLink();
  }

  void _handleIncomingLinks() {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _deepLinkSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        if(uri != null) {
          _router.applyRoute(_DeepLinkRoute(uri.toString()));
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

    return MaterialApp(
      title: title,
      theme: context.getOrNull(),
      navigatorKey: _navigatorKey,
      initialRoute: initialLink,
      onGenerateRoute: _router.onGenerateRoute,
      navigatorObservers:
          globalStore!.get<AnalyticsService>().navigatorObservers,
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocSupervisor.listener =
        globalStore!.get<AnalyticsService>().asBlocListener();
    globalStore!.get<UsageHistoryService>().openSession();

    return _wrapWithGlobalScope(MaterialApp(
      home: _SplashScreen(
        builder: splashBuilder!,
        loader: (context) => _initAsyncComponents(context),
        nextScreenBuilder: (context, initialLink) =>
            _wrapWithGlobalScope(buildApp(context, initialLink)),
      ),
    ));
  }

  @protected
  void initServices(BuildContext context, AplConfig config) {
    globalStore!
        .get<ResourceService>()
        .init(context, ResourceConfig.fromMap(config.resources));
    modules?.forEach((module) => module.init(context, config));
  }

  Store createDependencyTree() {
    final result = Store()
      ..add((provider) => SharedPreferences.getInstance())
      ..add((provider) => AnalyticsService(impls: analysts))
      ..add((provider) => UsageHistoryService(
          preferencesProvider: provider.get(),
          listener: provider.get<AnalyticsService>().asUsageListener()))
      ..add((provider) => ResourceService())
      ..add((provider) => _router);

    modules?.forEach((module) => module.addTo(result));

    return result;
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

class _DeepLinkRoute extends AplRoute {
  _DeepLinkRoute(String url) : super(url);
}
