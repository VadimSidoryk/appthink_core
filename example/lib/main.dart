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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await createFirebaseApp();
  print("starting App");
  runApp(MyApp(firebaseApp: firebaseApp));
}

Future<FirebaseApp> createFirebaseApp() async {
  return Firebase.initializeApp(
    name: 'db2',
    options: Platform.isAndroid
        ? FirebaseOptions(
            appId: '1:162446775805:android:f2ad2d9c200e989720b594',
            apiKey:
                'AAAAJdKVFf0:APA91bFyE7zKpUlVpGc43gjOKesDtDHxXOt6jNVj3oCbL7lu3eVztuZNfkEQiwvj0r_T1z6jtNvKnVT3Gg7tVlri8_Yxw60CH0NEnsEQCaneCyPaO7UBaIt6sIRUMfzESbSL9gUBRt2I',
            messagingSenderId: '162446775805',
            projectId: 'battler-65393',
            databaseURL: 'https://battler-65393-default-rtdb.firebaseio.com/',
          )
        : throw Exception(),
  );
}

class MyApp extends StatefulWidget {
  final FirebaseApp firebaseApp;

  const MyApp({@required this.firebaseApp}) : super();

  @override
  _MyAppState createState() => _MyAppState(firebaseApp);
}

class _MyAppState extends State<MyApp> {
  Map<int, Store> _battlesStores = {};
  Store _globalStore = Store()
    ..add<UserDetailsSource>((provider) => FirebaseUserSource())
    ..add((provider) => UserDetailsRepository(provider.get()));

  _MyAppState(FirebaseApp firebaseApp) {
    print("add firebase to globalStore");
    _globalStore.add((provider) => firebaseApp);
  }

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
}
