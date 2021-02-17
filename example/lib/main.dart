import 'package:applithium_core_example/details/data.dart';
import 'package:applithium_core_example/details/domain.dart';
import 'package:applithium_core_example/details/presentation.dart';
import 'package:applithium_core_example/top/data.dart';
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
  
  final battleModel = MockedBattlesSource().mockBattle();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slaps',
      debugShowCheckedModeBanner: false,
      home: Scope(
        store: Store()..add(BattleDetailsRepository(battleModel.id, MockedBattleDetailsSource(battleModel))..preloadData()),
        child: BattleDetailsScreen(),
      ),
    );
  }


}
