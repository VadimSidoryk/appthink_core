import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:applithium_core/applithium_core.dart';
import 'package:scoped/scoped.dart';

import 'home/HomeScreen.dart';



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
    return MaterialApp(
      title: 'Slaps',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }


}
