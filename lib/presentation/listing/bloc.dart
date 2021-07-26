import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/listing/repository.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';

abstract class BaseListEvent extends BaseEvents {

  @override
  Map<String, Object> get analyticParams => {};

  BaseListEvent(String name): super(name);
}

class Shown extends BaseListEvent {
  Shown() : super("screen_shown");
}

class UpdateRequested extends BaseListEvent {
  UpdateRequested() : super("screen_update");
}

class DisplayData<T> extends BaseListEvent {
  final T data;
  final isEndReached;

  DisplayData(this.data, this.isEndReached) : super("data_updated");
}

class ScrolledToEnd extends BaseListEvent {
  ScrolledToEnd() : super("scrolled_to_end");
}

class ListingState<T> extends BaseState<List<T>> {
  final bool isLoading;
  final bool isPageLoading;
  final bool isEndReached;

  ListingState(
      {List<T>? value,
      required this.isLoading,
      error,
      dialogModel,
      required this.isPageLoading,
      required this.isEndReached})
      : super(tag: STATE_BASE_ERROR_TAG, error: error, value: value);

  factory ListingState.initial() => ListingState(
      value: null,
      isLoading: true,
      error: null,
      isPageLoading: false,
      isEndReached: false);

  ListingState<T> withListData(List<T> value, bool endReached) {
    return ListingState(
        value: value,
        isLoading: false,
        error: null,
        isPageLoading: false,
        isEndReached: endReached);
  }

  ListingState<T> withLoading() {
    return ListingState(
        value: value,
        isLoading: true,
        error: null,
        isPageLoading: false,
        isEndReached: false);
  }

  @override
  ListingState<T> withError(dynamic error) {
    return ListingState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: isEndReached);
  }

  ListingState<T> withPageLoading() {
    return ListingState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: true,
        isEndReached: isEndReached);
  }

  ListingState<T> endReached() {
    return ListingState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: true);
  }
}

class ListingBloc<T> extends BaseBloc<ListingState<T>, ListingRepository> {
  ListingBloc(
      {required ListingRepository repository,
      required Presenters presenters,
      required Map<String, UseCase<List<T>>> domain})
      : super(
            initialState: ListingState.initial(),
            presenters: presenters,
            repository: repository,
            domain: domain);

  @override
  Stream<ListingState<T>> mapEventToStateImpl(AplEvent event) async* {
    switch (event.name) {
      case EVENT_CREATED_NAME:
        yield currentState.withLoading();
        repository.updateData(isForced: true);
        break;
      case EVENT_SCREEN_OPENED_NAME:
        repository.updateData(isForced: false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withLoading();
        final isUpdated = await repository.updateData(isForced: true);
        log("isUpdated: $isUpdated");
        break;
      case EVENT_SCROLLED_TO_END:
        if (!currentState.isPageLoading) {
          yield currentState.withPageLoading();
          repository.loadMoreItems();
        }
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withListData(
            event.params[EVENT_DATA_UPDATED_ARG_DATA] as List<T>,
            event.params[EVENT_DATA_UPDATED_ARG_IS_END_REACHED] as bool);
    }
  }
}
