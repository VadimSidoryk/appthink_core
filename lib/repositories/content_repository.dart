import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:applithium_core/use_case/base.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ContentRepository<T> extends BaseRepository<T> {

  @protected
  ContentRepositoryState state = ContentRepositoryState.INITIAL;

  bool _isOutdated = true;
  StreamSubscription? _subscription;

  CancelableOperation? _updateOperation;

  @protected
  final data = BehaviorSubject<T>();

  final int timeToLiveMillis;

  @override
  Stream<T> get updatesStream => data.stream;

  factory ContentRepository.simple(UseCase<dynamic, T> useCase) => _SimpleContentRepository(useCase);

  ContentRepository({this.timeToLiveMillis = 60 * 1000});

  Future<T> loadData();

  @override
  Future<bool> updateData(bool isCalledByUser) async {
    final needToUpdate = await checkNeedToUpdate(isCalledByUser);
    if (needToUpdate) {
      state = ContentRepositoryState.UPDATING;
      if(_updateOperation != null) {
        _updateOperation?.cancel();
        _updateOperation = null;
      }

      _updateOperation = CancelableOperation.fromFuture(
        loadData(),
        onCancel: () => { log("cancel update operation")});

      return (_updateOperation as CancelableOperation).valueOrCancellation(false).then((value) {
        onNewData(value);
        markAsUpdated();
        return true;
      }, onError: (ebj, exception) {
        logError(exception);
        //error flow we don't need to reset isOutdated field
        state = ContentRepositoryState.UPDATED;
        return false;
      });
    } else {
      return false;
    }
  }

  @protected
  void markAsOutdated() {
    if(_subscription != null) {
      _subscription?.cancel();
      _subscription = null;
    }
    
    _isOutdated = true;
  }

  @protected
  void markAsUpdated() {
    state = ContentRepositoryState.UPDATED;

    if(_subscription != null) {
      _subscription?.cancel();
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
  updateLocalData(FutureOr<T> Function(T) func) async {
    if (data.hasValue) {
      final newValue = await func(data.value);
      onNewData(newValue);
    }
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return state != ContentRepositoryState.UPDATING && (isForced || _isOutdated);
  }
}

enum ContentRepositoryState { INITIAL, UPDATING, UPDATED }

class _SimpleContentRepository<T> extends ContentRepository<T> {

  final UseCase<dynamic, T> useCase;

  _SimpleContentRepository(this.useCase);

  @override
  Future<T> loadData() {
    return useCase.loadData(null);
  }
}
