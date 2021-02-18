import 'package:applithium_core_example/profile/data.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:applithium_core_example/profile/presentation.dart';
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

  int _selectedIndex = 0;
  static const List<Widget> _pages = [
    TopBattlesPage(),
    TopBattlesPage(),
    UserDetailsPage(),
  ];

  static List<Store> _stores = [
    Store()..add(TopBattlesRepository(MockedBattlesSource())..preloadData()),
    Store()..add(TopBattlesRepository(MockedBattlesSource())..preloadData()),
    Store()..add(UserDetailsRepository(MockedUserSource())..preloadData()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scope(
        store: _stores[_selectedIndex],
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
