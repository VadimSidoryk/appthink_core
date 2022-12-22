import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

typedef Loader<P, T> = Future<T> Function(P);

abstract class WidgetResources {
  final BuildContext context;

  List<Subject> get subjects;

  WidgetResources(this.context);

  static BehaviorSubject<T> loadable<P, T>(Loader<P, T> loader, P params) {
    final result = BehaviorSubject<T>();
    loader.call(params).then((value) {
      result.add(value);
    });

    return result;
  }

  Future<void> waitForReady() {
    return Future.wait(subjects.map((e) => e.first));
  }
}




