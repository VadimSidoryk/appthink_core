import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'base_bloc.dart';

class ListingBloc<IM extends Equatable> extends BaseBloc<ListState<IM>> {
  final ListRepository<IM> _repository;

  StreamSubscription? _subscription;

  ListingBloc(this._repository, Presenters presenters)
      : super(ListState.initial(), presenters) {
    _subscription = _repository.updatesStream.listen((data) {
      add(AplEvent.displayListData(data.items, data.isEndReached));
    });
  }

  @override
  Stream<ListState<IM>> mapEventToStateImpl(AplEvent event) async* {
    switch (event.name) {
      case EVENT_SHOWN_NAME:
        _repository.updateData(false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withLoading(true);
        final isUpdated = await _repository.updateData(true);
        log("isUpdated: $isUpdated");
        yield currentState.withLoading(false);
        break;
      case EVENT_SCROLLED_TO_END:
        if (!currentState.isPageLoading) {
          yield currentState.withPageLoading(true);
          _repository.loadMoreItems();
        }
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withValue(
            event.params[EVENT_DATA_UPDATED_ARG_DATA] as List<IM>,
            event.params[EVENT_DATA_UPDATED_ARG_IS_END_REACHED] as bool);
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
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
      required this.isEndReached})
      : super(error);

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
