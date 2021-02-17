import 'package:applithium_core_example/top/data.dart';
import 'package:applithium_core_example/top/domain.dart';
import 'package:applithium_core_example/top/presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped/scoped.dart';

class HomeScreen extends StatefulWidget {

  static const routeName = "/";

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scope(
          store: Store()..add(TopBattlesRepository(MockedBattlesSource())..preloadData()),
          child: TopBattlesPage()),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            title: Text("Top"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text("Open"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
