import 'dart:async';

import 'package:applithium_core/repositories/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

const LISTING_LOADER_PAGE_SIZE_PARAM = "page_size";
const LISTING_LOADER_PAGE_COUNT_PARAM = "page_count";

class ListData<T> {
  final List<T> items;
  final bool isEndReached;

  ListData(this.items, this.isEndReached);
}

enum ListingRepositoryState {
  INITIAL,
  FIRST_PAGE_LOADING,
  FIRST_PAGE_LOADED,
  MORE_ITEMS_LOADING,
  MORE_ITEMS_LOADED
}

class ListingRepository<T>
    extends BaseRepository<List<T>> {
  ListingRepositoryState _state = ListingRepositoryState.INITIAL;

  final int pageSize;
  int _currentPage = 0;

  final _endReachedSubj = BehaviorSubject.seeded(false);

  final UseCase<List<T>> load;

  Stream<bool> get endReachedObs => _endReachedSubj.stream;

  ListingRepository(this.load,
      {int ttl = 60 * 1000, this.pageSize = 20})
      : super(ttl);

  Future<bool> updateData(bool isCalledByUser) async {
    final needToUpdate = await checkNeedToUpdate(isCalledByUser);

    if (needToUpdate) {
      _state = ListingRepositoryState.FIRST_PAGE_LOADING;
      cancelCurrentOperation();

      _currentPage = 0;
      final result = await apply(load.withParams(createLoadParams()));
      _endReachedSubj.sink.add(result);
      if (result) {
        _currentPage += 1;
      }

      return result;
    } else {
      return false;
    }
  }

  Map<String, dynamic> createLoadParams() =>
      {LISTING_LOADER_PAGE_SIZE_PARAM: pageSize, LISTING_LOADER_PAGE_COUNT_PARAM: _currentPage};

  @protected
  void markAsUpdated() {
    _state = ListingRepositoryState.FIRST_PAGE_LOADED;
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
    final result = await apply(load.withParams(createLoadParams()));
    _state = ListingRepositoryState.MORE_ITEMS_LOADED;
    _endReachedSubj.sink.add(result);
    if (result) {
      _currentPage += 1;
    }

    return result;
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != ListingRepositoryState.FIRST_PAGE_LOADING &&
        (isForced || isOutdated);
  }

  @protected
  Future<bool> checkNeedLoadMoreValues() async {
    return _state != ListingRepositoryState.MORE_ITEMS_LOADING &&
        _state != ListingRepositoryState.FIRST_PAGE_LOADING &&
        !await endReachedObs.first;
  }
}
