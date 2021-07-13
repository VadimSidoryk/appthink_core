import 'package:flutter/widgets.dart';

import 'store.dart';

class Scope extends InheritedWidget {
  final Store store;

  Scope(
      {required this.store,
      Widget? child,
      Widget Function(BuildContext)? builder,
      Key? key})
      : assert(child != null || builder != null),
        super(child: child ?? _WidgetBuilder(builder: builder!), key: key);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Scope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Scope>() as Scope;

  static T get<T>(BuildContext context, String key) {
    return of(context).store.get<T>(key: key);
  }

  static T? getOrNull<T>(BuildContext context, String key) {
    return of(context).store.getOrNull<T>(key: key);
  }
}

class _WidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const _WidgetBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder.call(context);
  }
}
