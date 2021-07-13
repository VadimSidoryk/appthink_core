import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/listing/repository.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';

class ListingState<T> extends BaseState {
  final List<T>? value;
  final bool isLoading;
  final bool isPageLoading;
  final bool isEndReached;

  ListingState(
      {this.value,
      required this.isLoading,
      error,
      dialogModel,
      required this.isPageLoading,
      required this.isEndReached})
      : super(STATE_BASE_ERROR_TAG, error);

  factory ListingState.initial() => ListingState(
      value: null,
      isLoading: true,
      error: null,
      isPageLoading: false,
      isEndReached: false);

  ListingState<T> withList(List<T> value, bool endReached) {
    return ListingState(
        value: value,
        isLoading: false,
        error: null,
        isPageLoading: this.isPageLoading,
        isEndReached: endReached);
  }

  ListingState<T> withListLoading(bool isLoading) {
    return ListingState(
        value: value,
        isLoading: true,
        error: null,
        isPageLoading: false,
        isEndReached: false);
  }

  ListingState<T> withError(dynamic error) {
    return ListingState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: isEndReached);
  }

  ListingState<T> withPageLoading(bool isPageLoading) {
    return ListingState(
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: isPageLoading,
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

class ListingBloc<IM> extends BaseBloc<ListingState<IM>, ListingRepository> {
  ListingBloc(
      {required ListingRepository repository,
      required Presenters presenters,
      required Map<String, UseCase<List<IM>>> domain})
      : super(
            initialState: ListingState.initial(),
            presenters: presenters,
            repository: repository,
            domain: domain);

  @override
  Stream<ListingState<IM>> mapEventToStateImpl(AplEvent event) async* {
    switch (event.name) {
      case EVENT_SHOWN_NAME:
        repository.updateData(false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withListLoading(true);
        final isUpdated = await repository.updateData(true);
        log("isUpdated: $isUpdated");
        yield currentState.withListLoading(false);
        break;
      case EVENT_SCROLLED_TO_END:
        if (!currentState.isPageLoading) {
          yield currentState.withPageLoading(true);
          repository.loadMoreItems();
          yield currentState.withPageLoading(false);
        }
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withList(
            event.params[EVENT_DATA_UPDATED_ARG_DATA] as List<IM>,
            event.params[EVENT_DATA_UPDATED_ARG_IS_END_REACHED] as bool);
    }
  }
}
