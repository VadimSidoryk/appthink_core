import 'dart:async';

import 'package:flutter/cupertino.dart';

typedef Loader<P, T> = Future<T> Function(P);

abstract class WidgetResources {
  final BuildContext context;

  List<Completer> get completerList;

  WidgetResources(this.context);

  @protected
  static Completer<T> loadable<P, T>(Loader<P, T> loader, P params) {
    final result = Completer<T>();
    loader.call(params).then((value) {
      result.complete(value);
    });

    return result;
  }

  Future<void> waitForReady() {
    return Future.wait(completerList.map((e) => e.future));
  }
}




