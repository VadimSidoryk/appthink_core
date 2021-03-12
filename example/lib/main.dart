import 'dart:io';

import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core_example/home/presentation.dart';
import 'package:applithium_core_example/profile/data.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'battle_details/data.dart';
import 'battle_details/domain.dart';
import 'battle_details/presentation.dart';
import 'battle_list/domain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Store> _battlesStores = {};
  Store _globalStore = Store()
    ..add<UserDetailsSource>((provider) => MockedUserSource())
    ..add((provider) => UserDetailsRepository(provider.get())..preloadData())
  ..add((provider) => createFirebaseApp());

  @override
  Widget build(BuildContext context) {
    return Scope(
        store: _globalStore,
        child: MaterialApp(
          initialRoute: HomeScreen.routeName,
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            HomeScreen.routeName: (context) => HomeScreen(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            BattleDetailsScreen.routeName: (context) {
              final BattleLiteModel model =
                  ModalRoute.of(context).settings.arguments;
              return Scope(
                  store: _getBattleStore(context, model),
                  child: BattleDetailsScreen());
            }
          },
        ));
  }

  Store _getBattleStore(BuildContext context, BattleLiteModel model) {
    if (_battlesStores.containsKey(model.id)) {
      return _battlesStores[model.id];
    } else {
      final result = Store.extend(context)
        ..add<BattleDetailsSource>(
            (provider) => MockedBattleDetailsSource(model))
        ..add((provider) =>
            BattleDetailsRepository(model.id, provider.get(), provider.get())
              ..preloadData())
        ..add((provider) =>
            MessagesRepository(model, provider.get(), provider.get())
              ..preloadData());
      _battlesStores[model.id] = result;
      return result;
    }
  }

  static Future<FirebaseApp> createFirebaseApp() async {
    return await Firebase.initializeApp(
      name: 'db2',
      options: Platform.isIOS || Platform.isMacOS
          ? throw Exception()
          : FirebaseOptions(
        appId: '1:162446775805:android:f2ad2d9c200e989720b594',
        apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
        messagingSenderId: '297855924061',
        projectId: 'flutter-firebase-plugins',
        databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
      ),
    )
  }
}
