import 'package:applithium_core_example/data/api.dart';
import 'package:applithium_core_example/exhibition/presentation.dart';
import 'package:applithium_core_example/exhibitions/domain.dart';
import 'package:applithium_core_example/exhibitions/presentation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:applithium_core/applithium_core.dart';
import 'package:scoped/scoped.dart';

import 'exhibition/domain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, Store> _exhibitionStores = {};
  Store _globalStore;

  @override
  Widget build(BuildContext context) {
    final token = "77a9aa7138f7c5bcc8a2fc3842681730";
    _globalStore = Store()
      ..addLazy<CooperHewittApi>(() => CooperHewittApiImpl(token));
    _globalStore.add(ExhibitionsRepository(_globalStore.get<CooperHewittApi>())
      ..preloadData());

    return MaterialApp(
      initialRoute: ExhibitionsScreen.routeName,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        ExhibitionsScreen.routeName : (context) => Scope(store: _globalStore, child: ExhibitionsScreen()),
        // When navigating to the "/second" route, build the SecondScreen widget.
       ExhibitionObjectsScreen.routeName : (context) {
          final exhibitionId = ModalRoute.of(context).settings.arguments;
          return Scope(
              store: _getExhibitionStore(exhibitionId), child: ExhibitionObjectsScreen());
        }
      },
    );
  }

  Store _getExhibitionStore(String exhibitionId) {
    if (_exhibitionStores.containsKey(exhibitionId)) {
      return  _exhibitionStores[exhibitionId];
    } else {
      final exhibitionStore = Store()
        ..add(ExhibitionObjectsRepository(
            _globalStore.get<CooperHewittApi>(), exhibitionId)
          ..preloadData());
      _exhibitionStores[exhibitionId] = exhibitionStore;
      return exhibitionStore;
    }
  }
}
