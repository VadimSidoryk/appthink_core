import 'dart:async';

import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:applithium_core/logs/extension.dart';

abstract class BaseRepository<T> {
  @protected
  final data = BehaviorSubject<T>();

  Stream<T> get updatesStream => data.stream;

  StreamSubscription? _operationSubscription;

  Future<bool> apply(UseCase<T> useCase) async {
    final completer = Completer<bool>();

    final dataValue = data.hasValue ? data.value : null;

    _operationSubscription = useCase
        .invoke(state: dataValue)
        .listen((data) => onNewData(data), onError: (error) {
      logError(error);
      _operationSubscription = null;
      completer.complete(false);
    }, onDone: () {
      _operationSubscription = null;
      completer.complete(true);
    });

    return completer.future;
  }

  @protected
  Future<bool> cancelCurrentOperation() async {
    if (_operationSubscription == null) {
      return false;
    }
    await _operationSubscription?.cancel();
    _operationSubscription = null;
    return true;
  }

  @protected
  void onNewData(T value) {
    data.sink.add(value);
  }

  void close() {
    data.close();
  }
}
