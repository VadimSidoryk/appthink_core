import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core/router/router.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'base_bloc.dart';

class ListBloc<Event extends BaseListEvents, VM extends Equatable>
    extends BaseBloc<BaseListEvents, ListState<VM>> {
  @protected
  final AplRouter router;

  final ListRepository<VM> _repository;

  StreamSubscription _subscription;

  ListBloc(this.router, this._repository)
      : super(ListState.initial()) {
    _subscription = _repository.updatesStream.listen((data) {
      add(DisplayData(data.items, data.isEndReached));
    });
  }

  @protected
  Stream<ListState<VM>> mapCustomEventToState(Event event) async* {}

  @override
  Stream<ListState<VM>> mapEventToStateImpl(BaseListEvents event) async* {
    if (event is Shown) {
      _repository.updateData(false);
    } else if (event is UpdateRequested) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if (event is ScrolledToEnd) {
      _repository.loadMoreItems();
    } else if (event is DisplayData<List<VM>>) {
      yield state.withValue(event.data, event.isEndReached);
    } else {
      yield* mapCustomEventToState(event);
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription.cancel();
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
  final List<T> value;
  final bool isLoading;
  final bool isPageLoading;
  final bool isEndReached;

  ListState(
      {this.value,
      this.isLoading,
      error,
      dialogModel,
      this.isPageLoading,
      this.isEndReached}): super(error, dialogModel);

  factory ListState.initial() => ListState(
      value: null,
      isLoading: true,
      error: null,
      dialogModel: null,
      isPageLoading: false,
      isEndReached: false);

  ListState<T> withValue(List<T> value, bool endReached) {
    return ListState(
        value: value,
        isLoading: false,
        error: null,
        dialogModel: dialogModel,
        isPageLoading: false,
        isEndReached: endReached);
  }

  ListState<T> withLoading(bool isLoading) {
    return ListState(
        value: value,
        isLoading: true,
        error: null,
        dialogModel: dialogModel,
        isPageLoading: false,
        isEndReached: false);
  }

  ListState<T> withError(dynamic error) {
    return ListState(
        value: value,
        isLoading: false,
        error: error,
        dialogModel: dialogModel,
        isPageLoading: false,
        isEndReached: isEndReached);
  }

  ListState<T> withPageLoading(bool isPageLoading) {
    return ListState(
        value: value,
        isLoading: false,
        error: error,
        dialogModel: dialogModel,
        isPageLoading: isPageLoading,
        isEndReached: isEndReached);
  }

  ListState<T> endReached() {
    return ListState(
        value: value,
        isLoading: false,
        error: error,
        dialogModel: dialogModel,
        isPageLoading: false,
        isEndReached: true);
  }

  ListState<T> showDialog(dynamic dialogModel) {
    return ListState(
        value: value,
        isLoading: isLoading,
        error: error,
        dialogModel: dialogModel,
        isPageLoading: isPageLoading,
        isEndReached: isEndReached);
  }

  ListState<T> hideDialog() {
    return ListState(
        value: value,
        isLoading: isLoading,
        error: error,
        dialogModel: null,
        isPageLoading: isPageLoading,
        isEndReached: isEndReached);
  }
}
