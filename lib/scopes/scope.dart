import 'package:flutter/widgets.dart';

import 'store.dart';

class Scope extends InheritedWidget {
  final Store store;

  Scope(
      { required BuildContext? parentContext,
      required this.store,
      required Widget Function(BuildContext) builder,
      Key? key})
      : super(
            child: _WidgetBuilder(builder: (BuildContext context) {
              final parentStore =
                  parentContext != null ? of(parentContext)?.store : null;
              if (parentStore != null) {
                store.extend(parentStore);
              }
              return builder.call(context);
            }),
            key: key);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Scope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Scope>();

  static T get<T>(BuildContext context, String key) {
    return of(context)!.store.get<T>(key: key);
  }

  static T? getOrNull<T>(BuildContext context, String key) {
    return of(context)?.store.getOrNull<T>(key: key);
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
