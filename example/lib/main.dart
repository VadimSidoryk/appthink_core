import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/mocks/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core/app/base.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return BaseAppState<MyApp, MyRouter>(
      splashBuilder: (config) => Scaffold(body: Center(child: Text("Splash...")),),
      title: "Applithium Core Sample",
        analysts: {LogAnalyst()},
        configProvider:() => MockUtils.mockWithDelay(Duration(seconds: 2), EmptyConfig()),
        routerBuilder: (key) => MyRouter(key));
  }
}

