import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/service.dart';
import 'package:applithium_core_example/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/presentation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  late Store globalStore;

  @override
  Widget build(BuildContext context) {
    globalStore = initDependencyTree();

    BlocSupervisor.listener = globalStore.get<Analytics>().blocListener;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scope(child: MyScreen(), store: globalStore),
      navigatorObservers: globalStore.get<Analytics>().navigatorObservers,
    );
  }

  Store initDependencyTree() {
    return Store()
      ..add((provider) => Analytics(impls: {LogAnalyst()}))
      ..add((provider) =>
          UsageHistoryService("example.app", SharedPreferences.getInstance()))
     ;
  }
}
