import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AplRepository<T> {
  @protected
  final data = BehaviorSubject<T>();

  T? get currentData => data.hasValue ? data.value : null;

  Stream<T> get updatesStream => data.stream;

  CancelableOperation? _cancelableOperation;
  @protected
  final int timeToLiveMillis;
  @protected
  bool isOutdated = true;

  AplRepository(this.timeToLiveMillis);

  Future<bool> applyInitial(UseCase<void, T> sourceOperation) async {
    final completer = Completer<bool>();

    await _cancelableOperation?.cancel();
    _cancelableOperation =
        CancelableOperation.fromFuture(sourceOperation.call(null)).then((data) {
      onNewData(data);
      completer.complete(true);
    }, onError: (error, stacktrace) {
      logError(error);
      completer.complete(false);
    }, onCancel: () {
      completer.complete(false);
    });

    return completer.future.whenComplete(() => _cancelableOperation = null);
  }

  Future<bool> apply(UseCase<T, T> operation,
      {resetOperationsStack = false}) async {
    final completer = Completer<bool>();

    if (resetOperationsStack || _cancelableOperation == null) {
      await _cancelableOperation?.cancel();
      final dataValue = data.value!;
      _cancelableOperation =
          CancelableOperation.fromFuture(operation.call(dataValue)).then(
              (data) {
        onNewData(data);
        completer.complete(true);
      }, onError: (error, stacktrace) {
        logError(error);
        completer.complete(false);
      }, onCancel: () {
        completer.complete(false);
      });
    } else {
      _cancelableOperation = _cancelableOperation!.then((data) {
        CancelableOperation.fromFuture(operation.call(data)).then((data) {
          onNewData(data);
          completer.complete(true);
        }, onError: (error, stacktrace) {
          logError(error);
          completer.complete(false);
        }, onCancel: () {
          completer.complete(false);
        });
      });
    }
    return completer.future.whenComplete(() => _cancelableOperation = null);
  }

  @protected
  Future<bool> cancelCurrentOperation() async {
    if (_cancelableOperation == null) {
      return false;
    }
    await _cancelableOperation!.cancel();
    _cancelableOperation = null;
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
