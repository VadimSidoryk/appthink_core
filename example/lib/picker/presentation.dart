import 'package:applithium_core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';

class PickerScreen extends StatelessWidget {
  static final items = [
    _PickerItem("Content Screen", "/content"),
    _PickerItem("List Screen", "/list")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, pos) => GestureDetector(
                  child: ListTile(title: Text(items[pos].title)),
                  onTap: () =>
                      context.get<AplRouter>().applyRoute(items[pos].path),
                )));
  }
}

class _PickerItem {
  final String title;
  final String path;

  _PickerItem(this.title, this.path);
}
