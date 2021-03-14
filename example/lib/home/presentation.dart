import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core_example/battle_list/data.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/battle_list/presentation.dart';
import 'package:applithium_core_example/bets_list/domain.dart';
import 'package:applithium_core_example/bets_list/presentation.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:applithium_core_example/profile/presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    TopBattlesListPage(),
    UserBetsListPage(),
    UserDetailsPage(),
  ];

  static Store createStore(BuildContext context, int index) {
      if(index == 0) {
        return  Store.extend(context)..add<BattlesSource>((provider) => MockedBattlesSource())
          ..add((provider) => BattleListRepository(provider.get())..preloadData());
      } else if(index == 1) {
        return Store.extend(context)..add((provider) => provider.get<UserDetailsRepository>().getUserBetsStream());
      } else {
        return null;
      }
  }

  static Map<int, Store> _stores = {};

  static Store getStore(BuildContext context, int index) {
    if(_stores.containsKey(index)) {
      return _stores[index];
    } else {
      final Store result = createStore(context, index);
      _stores[index] = result;
      return result;
     }
  }


  @override
  Widget build(BuildContext context) {
    Widget body;
    final store = getStore(context, _selectedIndex);
    if(store != null) {
      body = Scope(
        store: store,
        child: _pages[_selectedIndex],
      );
    } else {
      body = _pages[_selectedIndex];
    }

    return Scaffold(
      body: body,
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
