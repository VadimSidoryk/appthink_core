import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core_example/battle/data.dart';
import 'package:applithium_core_example/battle/domain.dart';
import 'package:applithium_core_example/battle/presentation.dart';
import 'package:applithium_core_example/home/presentation.dart';
import 'package:applithium_core_example/profile/data.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:applithium_core_example/top/domain.dart';
import 'package:flutter/material.dart';

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
    ..add((provider) => UserDetailsRepository(provider.get())..preloadData());

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
              final BattleItemModel model =
                  ModalRoute.of(context).settings.arguments;
              return Scope(
                  store: _getBattleStore(context, model),
                  child: BattleDetailsScreen());
            }
          },
        ));
  }

  Store _getBattleStore(BuildContext context, BattleItemModel model) {
    if (_battlesStores.containsKey(model.id)) {
      return _battlesStores[model.id];
    } else {
      final result = Store.extend(context)
        ..add<BattleDetailsSource>(
            (provider) => MockedBattleDetailsSource(model))
        ..add((provider) =>
            BattleDetailsRepository(model.id, provider.get(), provider.get())
              ..preloadData());
      _battlesStores[model.id] = result;
      return result;
    }
  }
}
