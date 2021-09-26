import 'package:applithium_core/app/base_state.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/services/localization/config.dart';
import 'package:applithium_core_example/app_graph.dart';
import 'package:applithium_core_firebase/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final appTitle = "Applithium Core Example";
final splashTitle = "Splash...";

final contentPath = "/content";
final listPath = "/list";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final NavigatorObserver? observer;
  final Future<String?> Function()? initialLinkProvider;
  final Locale? locale;
  final AplConfig config;

  MyApp(
      {this.observer,
      this.initialLinkProvider,
      this.locale,
      this.config = const AplConfig(
          messagingApiKey: "", localizations: LocalizationConfig({}))});

  @override
  State<StatefulWidget> createState() {
    return AplAppState<MyApp>(
        locale: locale,
        initialLinkProvider: initialLinkProvider,
        navObserver: observer,
        defaultConfig: config,
        splashBuilder: (config) => Scaffold(
              body: Center(child: Text(splashTitle)),
            ),
        title: appTitle,
        modules: {FirebaseModule()},
        routes: mainAppGraph);
  }
}
