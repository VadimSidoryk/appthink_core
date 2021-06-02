import 'package:applithium_core/config/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/app/base.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return BaseAppState<MyApp, _TestConfig>(
      splashBuilder: (config) => Scaffold(body: Center(child: Text("Splash...")),),
      title: "Flutter Demo",
        analysts: {LogAnalyst()},
        configProvider: _MockedConfigProvider(),
        routerBuilder: (key) => MyRouter(key));
  }
}

class _TestConfig extends AplConfig {
  @override
  Map<String, Map<String, String>> get resources => {
    "": {}
  };
}

class _MockedConfigProvider extends ConfigProvider<_TestConfig> {
  @override
  Future<_TestConfig> receiveConfig() {
    return Future.delayed(
        Duration(seconds: 5), () => Future.value(_TestConfig()));
  }
}
