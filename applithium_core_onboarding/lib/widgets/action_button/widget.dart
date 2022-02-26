import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'resources.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Function()? onClick;
  final EdgeInsets padding;

  const ActionButton(
      {Key? key,
      required this.title,
      required this.onClick,
      this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: padding,
        child: ElevatedButton(
            style: decorationAction,
            child: Text(title, style: styleAction),
            onPressed: onClick));
  }
}
