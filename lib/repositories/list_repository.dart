import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class ListData<T extends Equatable> {
  final List<T> items;
  final bool isEndReached;

  ListData(this.items, this.isEndReached);
}

abstract class ListRepository<T extends Equatable>
    extends BaseRepository<ListData<T>> {
  State _state = State.INITIAL;

  CancelableOperation _updateDataOperation;
  CancelableOperation _loadMoreItemsOperation;

  int _currentValueLength = 0;

  @protected
  final dataSubj = BehaviorSubject<List<T>>();

  final _endReachedSubj = BehaviorSubject.seeded(false);

  Stream<bool> get endReachedObs => _endReachedSubj.stream;

  final int defaultPageLength;

  @protected
  final Logger logger;

  Future<bool> isOutdated;

  @override
  Stream<ListData<T>> get updatesStream => CombineLatestStream.combine2(
      dataSubj.stream,
      _endReachedSubj.stream,
      (list, isEndReached) => ListData(list, isEndReached));

  ListRepository(this.defaultPageLength, {this.logger = const DefaultLogger()});

  Future<List<T>> loadItems(int startIndex, T lastValue, int itemsToLoad);

  @override
  Future<bool> updateData(bool isForced) async {
    final needToUpdate = await checkNeedToUpdate(isForced);
    if (_loadMoreItemsOperation != null) {
      _loadMoreItemsOperation.cancel();
      _loadMoreItemsOperation = null;
    }

    if (needToUpdate) {
      if (_updateDataOperation != null) {
        _updateDataOperation.cancel();
        _updateDataOperation = null;
      }
      _updateDataOperation = CancelableOperation.fromFuture(
          loadItems(0, null, defaultPageLength),
          onCancel: () => {logger.log("cancel update operation")});

      return _updateDataOperation.valueOrCancellation(false).then((value) {
        _endReachedSubj.sink.add(value.length < defaultPageLength);
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

  @protected
  Future<bool> updateItem(T item) async {
    if (await dataSubj.isEmpty) {
      return false;
    } else {
      final newValue = List.from(dataSubj.value);
      final itemIndex = newValue.indexOf(item);
      if (itemIndex != -1) {
        newValue[itemIndex] = item;
      }
      dataSubj.sink.add(newValue);
      return itemIndex != -1;
    }
  }

  @protected
  Future<bool> removeItem(T itemToRemove) async {
    if (await dataSubj.isEmpty) {
      return false;
    } else {
      final newValue = List.from(dataSubj.value);
      final isRemoved = newValue.remove(itemToRemove);
      onNewList(newValue);
      return isRemoved;
    }
  }

  @protected
  Future<bool> addItems(List<T> items) async {
    if (await dataSubj.isEmpty) {
      return false;
    } else {
      onNewList(dataSubj.value + items);
      return true;
    }
  }

  @override
  void close() {
    dataSubj.close();
    _endReachedSubj.close();
  }

  Future<bool> loadMoreItems() async {
    if (!await checkNeedLoadMoreValues()) {
      return false;
    }

    final lastElement = await dataSubj.isEmpty ? null : dataSubj.value.last;
    _loadMoreItemsOperation = CancelableOperation.fromFuture(
        loadItems(_currentValueLength, lastElement, defaultPageLength),
        onCancel: () => {logger.log("cancel loadMore operation")});

    return _loadMoreItemsOperation.valueOrCancellation(false).then((value) {
      _endReachedSubj.sink.add(value.length < defaultPageLength);
      return addItems(value);
    }, onError: () {
      logger.error(Exception("Can't update data"));
      return false;
    });
  }

  @protected
  void onNewList(List<T> value) {
    _currentValueLength = value.length;
    _updateDataOperation = null;
    _loadMoreItemsOperation = null;
    dataSubj.sink.add(value);
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != State.DATA_UPDATING && (isForced || await isOutdated);
  }

  @protected
  Future<bool> checkNeedLoadMoreValues() async {
    return _state != State.MORE_ITEMS_LOADING &&
        _state != State.DATA_UPDATING &&
        !await endReachedObs.first;
  }
}

enum State {
  INITIAL,
  DATA_UPDATING,
  DATA_UPDATED,
  MORE_ITEMS_LOADING,
  MORE_ITEMS_LOADED
}
