import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core/services/localization/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const CONTENT_SCREEN_TITLE = "Content Screen";
const LIST_SCREEN_TITLE = "List Screen";

class PickerScreen extends StatelessWidget {
  static final items = [
    _PickerItem(CONTENT_SCREEN_TITLE, "/content"),
    _PickerItem(LIST_SCREEN_TITLE, "/list")
  ];

  @override
  Widget build(BuildContext context) {
    log("build");
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, pos) => GestureDetector(
                  child: ListTile(title: Text(items[pos].title).tr(context)),
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
