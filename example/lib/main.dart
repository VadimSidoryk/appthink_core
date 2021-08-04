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

final appTitle = "Applithium Core Example";
final splashTitle = "Splash...";

final contentPath = "content";
final listPath = "list";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  Stream<Route>? routeObs;

  @override
  State<StatefulWidget> createState() {
    final result = AplAppState<MyApp>(
        defaultConfig: AplConfig.getDefault(),
        splashBuilder: (config) => Scaffold(
              body: Center(child: Text(splashTitle)),
            ),
        title: appTitle,
        modules: {
          FirebaseModule()
        },
        routes: [
          RouteDetails(
              builder: (context, result) => PickerScreen(),
              subRoutes: [
                RouteDetails(
                    matcher: Matcher.path(contentPath),
                    builder: presentationScope((context) => ContentScreen())),
                RouteDetails(
                    matcher: Matcher.path(listPath),
                    builder: presentationScope((context) => ListingScreen())),
              ])
        ]);
    routeObs = result.routesObs;
    return result;
  }
}
