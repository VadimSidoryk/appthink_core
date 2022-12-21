import 'package:flutter/cupertino.dart';

typedef Loader<P, T> = Future<T> Function(P);

abstract class LoadableType<P, T> {
  Loader<P, T> get loader;
}

class WidgetResources {
  final BuildContext context;

  WidgetResources(this.context);

  @protected
  Future<T> loadable<P, T>(LoadableType<P, T> type, P params) {
    return type.loader.call(params);
  }
}
