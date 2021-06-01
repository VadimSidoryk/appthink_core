import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Store? _globalStore;
  WidgetsBindingObserver? _widgetObserver;


  @override
  initState() {
    _globalStore = initDependencyTree();
    _widgetObserver = _globalStore!.get<UsageHistoryService>().asWidgetObserver();
    super.initState();
    if(_widgetObserver != null) {
      WidgetsBinding.instance?.addObserver(_widgetObserver!);
    }
  }

  @override
  void dispose() {
    if(_widgetObserver != null) {
      WidgetsBinding.instance?.removeObserver(_widgetObserver!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocSupervisor.listener = _globalStore!.get<Analytics>().asBlocListener();

    _globalStore!.get<UsageHistoryService>().openSession();

    final router = _globalStore!.get<MyRouter>();

    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: _navigatorKey,
      initialRoute: router.startRoute,
      routes: router.routes,
      navigatorObservers: _globalStore!.get<Analytics>().navigatorObservers,
    );
  }

  Store initDependencyTree() {
    return Store()
      ..add((provider) => Analytics(impls: {LogAnalyst()}))
      ..add((provider) => UsageHistoryService(
          preferencesName: "example.app",
          preferencesProvider: SharedPreferences.getInstance(),
          listener: provider.get<Analytics>().asUsageListener()))
      ..add((provider) => MyRouter(_navigatorKey));
  }

}
