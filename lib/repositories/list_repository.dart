import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:applithium_core/use_case/base.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class ListData<T extends Equatable> {
  final List<T> items;
  final bool isEndReached;

  ListData(this.items, this.isEndReached);
}

enum ListingRepositoryState {
  INITIAL,
  DATA_UPDATING,
  DATA_UPDATED,
  MORE_ITEMS_LOADING,
  MORE_ITEMS_LOADED
}

abstract class ListingRepository<T extends Equatable>
    extends BaseRepository<ListData<T>> {

  ListingRepositoryState _state = ListingRepositoryState.INITIAL;

  CancelableOperation? _updateDataOperation;
  CancelableOperation? _loadMoreItemsOperation;

  int _currentValueLength = 0;

  final _endReachedSubj = BehaviorSubject.seeded(false);

  Stream<bool> get endReachedObs => _endReachedSubj.stream;

  final int defaultPageLength;

  bool _isOutdated = true;
  StreamSubscription? _subscription;

  final int timeToLiveMillis;

  @override
  Stream<ListData<T>> get updatesStream => CombineLatestStream.combine2(
      data.stream,
      _endReachedSubj.stream,
      (List<T> list, bool isEndReached) => ListData(list, isEndReached));

  factory ListingRepository.simple(UseCase<dynamic, List<T>> useCase) => _SimpleListRepository(useCase);

  ListingRepository(this.defaultPageLength, {this.timeToLiveMillis = 60 * 1000});

  Future<List<T>> loadItems(int startIndex, T? lastValue, int itemsToLoad);

  @override
  Future<bool> updateData(bool isCalledByUser) async {
    final needToUpdate = await checkNeedToUpdate(isCalledByUser);
    _loadMoreItemsOperation?.cancel();
    _loadMoreItemsOperation = null;


    if (needToUpdate) {
      _state = ListingRepositoryState.DATA_UPDATING;
      _updateDataOperation?.cancel();
      _updateDataOperation = null;

      _updateDataOperation = CancelableOperation.fromFuture(
          loadItems(0, null, defaultPageLength),
          onCancel: () => {log("cancel update operation")});

      return (_updateDataOperation as CancelableOperation).valueOrCancellation(false).then((value) {
        markAsUpdated();
        _endReachedSubj.sink.add(value.length < defaultPageLength);
        onNewList(value);
        return true;
      }, onError: (obj, exception) {
        logError(Exception(exception));
        //error flow we don't need to reset isOutdated field
        _state = ListingRepositoryState.DATA_UPDATED;
        return false;
      });
    } else {
      return false;
    }
  }

  @protected
  void markAsOutdated() {
    _subscription?.cancel();
    _subscription = null;


    _isOutdated = true;
  }

  @protected
  void markAsUpdated() {
    _state = ListingRepositoryState.DATA_UPDATED;

    _subscription?.cancel();
    _subscription = null;

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
    _endReachedSubj.close();
  }

  Future<bool> loadMoreItems() async {
    if (!await checkNeedLoadMoreValues()) {
      return false;
    }

    _state = ListingRepositoryState.MORE_ITEMS_LOADING;

    final lastElement = (await data.first).last;
    _loadMoreItemsOperation = CancelableOperation.fromFuture(
        loadItems(_currentValueLength, lastElement, defaultPageLength),
        onCancel: () => {log("cancel loadMore operation")});

    return (_loadMoreItemsOperation as CancelableOperation).valueOrCancellation(false).then((value) {
      _state = ListingRepositoryState.MORE_ITEMS_LOADED;
      _endReachedSubj.sink.add(value.length < defaultPageLength);
      return addItems(value);
    }, onError: (obj, exception) {
      logError(exception);
      return false;
    });
  }

  @protected
  void onNewList(List<T> value) {
    _currentValueLength = value.length;
    _updateDataOperation = null;
    _loadMoreItemsOperation = null;
    data.sink.add(value);
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != ListingRepositoryState.DATA_UPDATING && (isForced || _isOutdated);
  }

  @protected
  Future<bool> checkNeedLoadMoreValues() async {
    return _state != ListingRepositoryState.MORE_ITEMS_LOADING &&
        _state != ListingRepositoryState.DATA_UPDATING &&
        !await endReachedObs.first;
  }
}
