import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseRepository<T> {
  @protected
  final data = BehaviorSubject<T>();

  Stream<T> get updatesStream => data.stream;

  StreamSubscription? _operationSubscription;
  @protected
  final int timeToLiveMillis;
  @protected
  bool isOutdated = true;

  BaseRepository(this.timeToLiveMillis);

  Future<bool> apply(FutureOr<T> Function(T?) mapper) async {
    final completer = Completer<bool>();

    final dataValue = data.hasValue ? data.value : null;

    _operationSubscription = mapper.call(dataValue).listen((data) => onNewData(data), onError: (error) {
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

  @protected
  void markAsOutdated() {
    cancelCurrentOperation();
    isOutdated = true;
  }

  @protected
  void markAsUpdated() {
    cancelCurrentOperation();
    isOutdated = false;

    _operationSubscription =
        Future.delayed(Duration(milliseconds: timeToLiveMillis), () {
      return true;
    }).asStream().listen((value) {
      isOutdated = value;
      _operationSubscription = null;
    });
  }

  void close() {
    data.close();
  }
}
