import 'package:flutter/widgets.dart';

import 'store.dart';

class Scope extends InheritedWidget {
  final Store store;
  Scope({required this.store, required Widget child, Key? key})
      : super(child: child, key: key);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Scope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Scope>() as Scope;

  static T get<T>(BuildContext context) {
    return of(context).store.get<T>();
  }

  static T? getOrNull<T>(BuildContext context) {
    return of(context).store.getOrNull<T>();
  }
}