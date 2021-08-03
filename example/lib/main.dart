import 'package:applithium_core/app/base_state.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/router/matchers.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core_example/listing/presentation.dart';
import 'package:applithium_core_example/picker/presentation.dart';
import 'package:applithium_core_firebase/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'content/presentation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AplAppState<MyApp>(
        defaultConfig: AplConfig.getDefault(),
        splashBuilder: (config) => Scaffold(
              body: Center(child: Text("Splash...")),
            ),
        title: "Applithium Core Example",
        modules: {
          FirebaseModule()
        },
        routes: [
          RouteDetails(
              builder: (context, result) => PickerScreen(),
              subRoutes: [
                RouteDetails(
                    matcher: Matcher.path("content"),
                    builder: presentationScope((context) => ContentScreen())),
                RouteDetails(
                    matcher: Matcher.path("list"),
                    builder: presentationScope((context) => ListingScreen())),
              ])
        ]);
  }
}
