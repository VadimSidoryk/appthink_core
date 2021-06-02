import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/services/resources/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/logs/extension.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return _MyAppState(
        analysts: {LogAnalyst()},
        configProvider: _MockedConfigProvider(),
        routerBuilder: (key) => MyRouter(key));
  }
}

class _MyAppState<C extends AplConfig> extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Store? _globalStore;
  final ConfigProvider<C> configProvider;
  final Set<Analyst> analysts;
  late MainRouter _router;
  WidgetsBindingObserver? _widgetObserver;

  _MyAppState(
      {required this.configProvider,
      required MainRouter Function(GlobalKey<NavigatorState>) routerBuilder,
      required this.analysts}) {
    _router = routerBuilder.call(_navigatorKey);
  }

  @override
  initState() {
    log("initState");
    super.initState();
    _initStateImpl();
  }

  @override
  void dispose() {
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    super.dispose();
  }

  Future<void> _initStateImpl() async {
    _globalStore = createDependencyTree();
    log("globalStore created");
    _widgetObserver =
        _globalStore!.get<UsageHistoryService>().asWidgetObserver();
    if (_widgetObserver != null) {
      WidgetsBinding.instance?.addObserver(_widgetObserver!);
    }

    final C config = await configProvider.receiveConfig();
    log("config received");
    initServices(config);
  }

  @override
  Widget build(BuildContext context) {
    log("build called");

    BlocSupervisor.listener =
        _globalStore!.get<AnalyticsService>().asBlocListener();
    _globalStore!.get<UsageHistoryService>().openSession();

    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: _navigatorKey,
      initialRoute: _router.startRoute,
      routes: _router.routes,
      navigatorObservers:
          _globalStore!.get<AnalyticsService>().navigatorObservers,
    );
  }

  void initServices(C config) {
    _globalStore!
        .get<ResourceService>()
        .init(context, ResourceConfig.fromMap(config.resources));
  }

  Store createDependencyTree() {
    return Store()
      ..add((provider) => AnalyticsService(impls: analysts))
      ..add((provider) => UsageHistoryService(
          preferencesProvider: SharedPreferences.getInstance(),
          listener: provider.get<AnalyticsService>().asUsageListener()))
      ..add((provider) => ResourceService())
      ..add((provider) => _router);
  }
}

class _TestConfig extends AplConfig {
  @override
  Map<String, Map<String, String>> get resources => {};
}

class _MockedConfigProvider extends ConfigProvider<_TestConfig> {
  @override
  Future<_TestConfig> receiveConfig() {
    return Future.delayed(
        Duration(seconds: 2), () => Future.value(_TestConfig()));
  }
}
