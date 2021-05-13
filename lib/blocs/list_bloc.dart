import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'base_bloc.dart';

class ListBloc<IM extends Equatable>
    extends BaseBloc<ListState<IM>> {

  final ListRepository<IM> _repository;

  StreamSubscription? _subscription;

  ListBloc(this._repository)
      : super(ListState.initial()) {
    _subscription = _repository.updatesStream.listen((data) {
      add(DisplayData(data.items, data.isEndReached));
    });
  }

  @override
  Stream<ListState<IM>> mapEventToStateImpl(BaseEvents event) async* {
    if (event is Shown) {
      _repository.updateData(false);
    } else if (event is UpdateRequested) {
      yield currentState.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      log("isUpdated: $isUpdated");
      yield currentState.withLoading(false);
    } else if (event is ScrolledToEnd) {
      _repository.loadMoreItems();
    } else if (event is DisplayData<List<IM>>) {
      yield currentState.withValue(event.data, event.isEndReached);
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}

abstract class BaseListEvents extends BaseEvents {
  @override
  final String analyticTag;

  @override
  Map<String, Object> get analyticParams => {};

  BaseListEvents(this.analyticTag): super(analyticTag);
}

class UpdateRequested extends BaseListEvents {
  UpdateRequested() : super("screen_update");
}

class DisplayData<T> extends BaseListEvents {
  final T data;
  final isEndReached;

  DisplayData(this.data, this.isEndReached) : super("data_updated");
}

class ScrolledToEnd extends BaseListEvents {
  ScrolledToEnd() : super("scrolled_to_end");
}

class ListState<T> extends BaseState {
  final List<T>? value;
  final bool isLoading;
  final bool isPageLoading;
  final bool isEndReached;

  ListState(
      {this.value,
      required this.isLoading,
      error,
      dialogModel,
      required this.isPageLoading,
      required this.isEndReached}): super(error);

  factory ListState.initial() => ListState(
      value: null,
      isLoading: true,
      error: null,
      isPageLoading: false,
      isEndReached: false);

  ListState<T> withValue(List<T> value, bool endReached) {
    return ListState(
        value: value,
        isLoading: false,
        error: null,
        isPageLoading: false,
        isEndReached: endReached);
  }

  ListState<T> withLoading(bool isLoading) {
    return ListState(
        value: value,
        isLoading: true,
        error: null,
        isPageLoading: false,
        isEndReached: false);
  }

  ListState<T> withError(dynamic error) {
    return ListState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: isEndReached);
  }

  ListState<T> withPageLoading(bool isPageLoading) {
    return ListState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: isPageLoading,
        isEndReached: isEndReached);
  }

  ListState<T> endReached() {
    return ListState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: true);
  }
}
