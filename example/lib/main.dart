import 'package:applithium_core/app/base.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/mocks/utils.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return BaseAppState<MyApp>(
        splashBuilder: (config) => Scaffold(
              body: Center(child: Text("Splash...")),
            ),
        title: "Applithium Core Example",
        analysts: {LogAnalyst()},
        configProvider: MockedConfigProvider(),
        routerBuilder: (key) => MyRouter(key));
  }
}

class MockedConfigProvider extends ConfigProvider {
  @override
  Future<AplConfig> getApplicationConfig() {
    return MockUtils.mockWithDelay(
        Duration(seconds: 2), AplConfig(resources: {}, eventHandlers: {}));
  }
}
