import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

abstract class ListRepository<T> extends BaseRepository<List<T>> {
  State _state = State.INITIAL;

  CancelableOperation _updateDataOperation;
  CancelableOperation _loadMoreItemsOperation;

  int _currentValueLength = 0;
  bool _hasMoreValues = true;

  final int defaultPageLength;

  @protected
  final Logger logger;

  Future<bool> isOutdated;

  @protected
  final data = BehaviorSubject<List<T>>();

  @override
  Stream<List<T>> get dataStream => data.stream;

  ListRepository(this.defaultPageLength, { this.logger = const DefaultLogger() });

  Future<List<T>> loadItems(int startIndex, T lastValue, int itemsToLoad);

  @override
  Future<bool> updateData(bool isForced) async {
    final needToUpdate = await checkNeedToUpdate(isForced);
    if(_loadMoreItemsOperation != null) {
      _loadMoreItemsOperation.cancel();
      _loadMoreItemsOperation = null;
    }

    if (needToUpdate) {
      if(_updateDataOperation != null) {
        _updateDataOperation.cancel();
        _updateDataOperation = null;
      }
      _updateDataOperation = CancelableOperation.fromFuture(
          loadItems(0, null, defaultPageLength),
          onCancel: () => {logger.log("cancel update operation")});

      return _updateDataOperation.valueOrCancellation(false).then((value) {
        onNewList(value);
        return true;
      }, onError: () {
        logger.error(Exception("Can't update data"));
        return false;
      });
    } else {
      return false;
    }
  }

  @override
  void close() {
    data.close();
  }

  Future<bool> loadMoreItems() async {
    if (!await checkNeedLoadMoreValues()) {
      return false;
    }

    final lastElement = await data.isEmpty ? null : data.value.last;
    _loadMoreItemsOperation = CancelableOperation.fromFuture(
        loadItems(_currentValueLength, lastElement, defaultPageLength),
        onCancel: () => {logger.log("cancel loadMore operation")});

    return _loadMoreItemsOperation.valueOrCancellation(false).then((value) {
      onNewItems(value);
      return true;
    }, onError: () {
      logger.error(Exception("Can't update data"));
      return false;
    });
  }

  @protected
  void onNewList(List<T> value) {
    _currentValueLength = value.length;
    _hasMoreValues = value.length == defaultPageLength;
    _updateDataOperation = null;
    data.sink.add(value);
  }

  @protected
  void onNewItems(List<T> value) {
    _currentValueLength = _currentValueLength + value.length;
    _hasMoreValues = value.length == defaultPageLength;
    _loadMoreItemsOperation = null;
    final resultList = data.value + value;
    data.sink.add(resultList);
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != State.DATA_UPDATING && (isForced || await isOutdated);
  }

  @protected
  Future<bool> checkNeedLoadMoreValues() async {
    return _state != State.MORE_ITEMS_LOADING && _state != State.DATA_UPDATING && _hasMoreValues;
  }
}

enum State {
  INITIAL,
  DATA_UPDATING,
  DATA_UPDATED,
  MORE_ITEMS_LOADING,
  MORE_ITEMS_LOADED
}
