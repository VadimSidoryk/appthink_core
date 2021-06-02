import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/services/resources/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:applithium_core/logs/extension.dart';

class BaseAppState<A extends StatefulWidget, C extends AplConfig>
    extends State<A> {
  final String title;
  final _navigatorKey = GlobalKey<NavigatorState>();
  @protected
  Store? globalStore;
  final ConfigProvider<C> configProvider;
  final Set<Analyst> analysts;
  late MainRouter _router;
  WidgetsBindingObserver? _widgetObserver;
  final Widget Function(BuildContext) splashBuilder;
  final Set<Module> modules;

  BaseAppState(
      {required this.title,
      required this.configProvider,
      required MainRouter Function(GlobalKey<NavigatorState>) routerBuilder,
      required this.splashBuilder,
      required this.analysts,
      required this.modules}) {
    _router = routerBuilder.call(_navigatorKey);
  }

  @override
  initState() {
    log("initState");
    super.initState();
    _initSyncComponents();
  }

  @override
  void dispose() {
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
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

  Future<void> _initAsyncComponents(BuildContext context) async {
    logMethod(methodName: "initAsyncComponents");
    final C config = await configProvider.receiveConfig();
    log("config received");
    initServices(context, config);
    log("services initialized");
  }

  @protected
  Widget buildApp(BuildContext context) {
    logMethod(methodName: "buildApp");
    return MaterialApp(
      title: title,
      navigatorKey: _navigatorKey,
      initialRoute: _router.startRoute,
      routes: _router.routes,
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
        builder: splashBuilder,
        loader: (context) => _initAsyncComponents(context),
        nextScreenBuilder: (context) => _wrapWithGlobalScope(buildApp(context)),
      ),
    ));
  }

  @protected
  void initServices(BuildContext context, C config) {
    globalStore!
        .get<ResourceService>()
        .init(context, ResourceConfig.fromMap(config.resources));
    modules.forEach((module) => module.init(context, config));
  }

  Store createDependencyTree() {
    final result = Store()
      ..add((provider) => AnalyticsService(impls: analysts))
      ..add((provider) => UsageHistoryService(
          preferencesProvider: SharedPreferences.getInstance(),
          listener: provider.get<AnalyticsService>().asUsageListener()))
      ..add((provider) => ResourceService())
      ..add((provider) => _router);

    modules.forEach((module) => result.add(module.create));

    return result;
  }

  Widget _wrapWithGlobalScope(Widget wrapped) {
    return Scope(store: globalStore!, child: wrapped);
  }
}

class _SplashScreen extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  final Widget Function(BuildContext) nextScreenBuilder;
  final Future<void> Function(BuildContext) loader;

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
    await loader.call(context);
    Navigator.push(context, MaterialPageRoute(builder: nextScreenBuilder));
  }
}
