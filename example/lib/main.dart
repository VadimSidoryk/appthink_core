import 'package:applithium_core_example/data/api.dart';
import 'package:applithium_core_example/exhibition/presentation.dart';
import 'package:applithium_core_example/exhibitions/domain.dart';
import 'package:applithium_core_example/exhibitions/presentation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:applithium_core/applithium_core.dart';
import 'package:scoped/scoped.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final token = "77a9aa7138f7c5bcc8a2fc3842681730";
    final globalStore = Store()
      ..addLazy<CooperHewittApi>(() => CooperHewittApiImpl(token));
    globalStore.addLazy(() => ExhibitionsRepository(globalStore.get<CooperHewittApi>()));

    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => ExhibitionsScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/exhibition_objects': (context) => ExhibitionObjectsScreen(),
      },
    );
  }
}
