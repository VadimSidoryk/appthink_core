import 'package:applithium_core/app/base.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core_example/test/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return ApplithiumAppState<MyApp>(
        splashBuilder: (config) => Scaffold(
              body: Center(child: Text("Splash...")),
            ),
        title: "Applithium Core Example",
        analysts: {LogAnalyst()},
        routes: [RouteDetails(builder: (context, result) => TestWidget())]);
  }
}
