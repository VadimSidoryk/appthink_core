import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/localization/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const CONTENT_SCREEN_TITLE = "Content screen";
const LIST_SCREEN_TITLE = "List screen";

class PickerScreen extends StatelessWidget {
  static final items = [
    PickerItem(CONTENT_SCREEN_TITLE, "/content"),
    PickerItem(LIST_SCREEN_TITLE, "/list")
  ];

  final Function(PickerItem) itemClicked;

  const PickerScreen({Key? key, required this.itemClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build");
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, pos) => GestureDetector(
                child: ListTile(title: Text(items[pos].title).tr(context)),
                onTap: () => itemClicked.call(items[pos]))));
  }
}

class PickerItem {
  final String title;
  final String path;

  PickerItem(this.title, this.path);
}
