import 'dart:async';

import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ContentRepository<T> extends BaseRepository<T> {
  State _state = State.INITIAL;

  @protected
  final Logger logger;

  bool _isOutdated = true;
  StreamSubscription _subscription;

  @protected
  final data = BehaviorSubject<T>();

  final int timeToLiveMillis;

  @override
  Stream<T> get updatesStream => data.stream;

  ContentRepository( {this.logger = const DefaultLogger("ContentRepository"), this.timeToLiveMillis = 60 * 1000});

  Future<T> loadData();

  @override
  Future<bool> updateData(bool isCalledByUser) async {
    final needToUpdate = await checkNeedToUpdate(isCalledByUser);
    if (needToUpdate) {
      _state = State.UPDATING;
      return loadData().then((value) {
        onNewData(value);
        markAsUpdated();
        return true;
      }, onError: (ebj, exception) {
        logger.error(exception);
        //error flow we don't need to reset isOutdated field
        _state = State.UPDATED;
        return false;
      });
    } else {
      return false;
    }
  }

  @protected
  void markAsOutdated() {
    if(_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
    
    _isOutdated = true;
  }

  @protected
  void markAsUpdated() {
    _state = State.UPDATED;

    if(_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    _isOutdated = false;
    
   _subscription = Future.delayed(Duration(milliseconds: timeToLiveMillis), () { return true; })
        .asStream()
        .listen((value) {
          _isOutdated = value;
          _subscription = null;
    });
  }

  @override
  void close() {
    data.close();
  }

  @protected
  void onNewData(T value) {
    data.sink.add(value);
  }

  @protected
  updateLocalData(T func(T)) {
    if (data.hasValue) {
      data.sink.add(func(data.value));
    }
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != State.UPDATING && (isForced || _isOutdated);
  }
}

enum State { INITIAL, UPDATING, UPDATED }
