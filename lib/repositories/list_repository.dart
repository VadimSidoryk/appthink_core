import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

const LOADER_PAGE_SIZE_PARAM = "page_size";

class ListData<T extends Equatable> {
  final List<T> items;
  final bool isEndReached;

  ListData(this.items, this.isEndReached);
}

enum ListingRepositoryState {
  INITIAL,
  INITIAL_DATA_LOADING,
  INITIAL_DATA_LOADED,
  MORE_ITEMS_LOADING,
  MORE_ITEMS_LOADED
}

abstract class ListingRepository<T extends Equatable>
    extends BaseRepository<List<T>> {
  ListingRepositoryState _state = ListingRepositoryState.INITIAL;

  int _currentValueLength = 0;

  final _endReachedSubj = BehaviorSubject.seeded(false);

  final UseCase<List<T>> load;
  UseCase<List<T>>? currentLoadOperation;

  Stream<bool> get endReachedObs => _endReachedSubj.stream;

  ListingRepository(this.load, {int timeToLiveMillis = 60 * 1000})
      : super(timeToLiveMillis);

  Future<List<T>> loadItems(int startIndex, T? lastValue, int itemsToLoad);

  Future<bool> updateData(bool isCalledByUser) async {
    final needToUpdate = await checkNeedToUpdate(isCalledByUser);

    if (needToUpdate) {
      _state = ListingRepositoryState.INITIAL_DATA_LOADING;
      cancelCurrentOperation();

      currentLoadOperation = load.withParams({LOADER_PAGE_COUNT_PARAM: 0});
      return apply(currentLoadOperation as UseCase<List<T>>);
    } else {
      return false;
    }
  }

  @protected
  void markAsUpdated() {
    _state = ListingRepositoryState.INITIAL_DATA_LOADED;
    super.markAsUpdated();
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

    final result = apply(currentLoadOperation.withParams(params);
    _loadMoreItemsOperation = CancelableOperation.fromFuture(
        loadItems(_currentValueLength, lastElement, defaultPageLength),
        onCancel: () => {log("cancel loadMore operation")});

    return (_loadMoreItemsOperation as CancelableOperation)
        .valueOrCancellation(false)
        .then((value) {
      _state = ListingRepositoryState.MORE_ITEMS_LOADED;
      _endReachedSubj.sink.add(value.length < defaultPageLength);
      return addItems(value);
    }, onError: (obj, exception) {
      logError(exception);
      return false;
    });
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != ListingRepositoryState.INITIAL_DATA_LOADING &&
        (isForced || isOutdated);
  }

  @protected
  Future<bool> checkNeedLoadMoreValues() async {
    return _state != ListingRepositoryState.MORE_ITEMS_LOADING &&
        _state != ListingRepositoryState.INITIAL_DATA_LOADING &&
        !await endReachedObs.first;
  }
}
