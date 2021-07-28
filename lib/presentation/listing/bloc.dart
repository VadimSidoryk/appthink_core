import 'dart:async';

import 'package:applithium_core/json/mappable.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/content/bloc.dart';
import 'package:applithium_core/presentation/listing/mappable_list.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';
import '../repository.dart';

const STATE_LISTING_INITIAL_TAG = "list_initial";
const STATE_LISTING_LOADING_TAG = "list_loading";
const STATE_LISTING_LOADING_FAILED_TAG = "list_loading_failed";
const STATE_LISTING_LOADED_TAG = "list_loaded";
const STATE_LISTING_PAGE_LOADING = "list_page_loading";
const STATE_LISTING_PAGE_LOADED = "list_page_loaded";
const STATE_LISTING_PAGE_LOADING_FAILED = "list_page_loading_failed";

abstract class BaseListEvent extends BaseEvents {
  @override
  Map<String, Object> get analyticParams => {};

  BaseListEvent(String name) : super(name);
}

class DisplayData<T> extends BaseListEvent {
  final T data;
  final isEndReached;

  DisplayData(this.data, this.isEndReached) : super("data_updated");
}

class ScrolledToEnd extends BaseListEvent {
  ScrolledToEnd() : super("scrolled_to_end");
}

class ListingState<M extends Mappable> extends BaseState<MappableList<M>> {
  final bool isLoading;
  final bool isPageLoading;
  final bool isEndReached;

  ListingState(
      {required String tag,
      List<M>? value,
      required this.isLoading,
      error,
      dialogModel,
      required this.isPageLoading,
      required this.isEndReached})
      : super(tag: tag, error: error, value: value != null ? MappableList(value) : null);

  factory ListingState.initial() => ListingState(
      tag: STATE_LISTING_INITIAL_TAG,
      value: null,
      isLoading: true,
      error: null,
      isPageLoading: false,
      isEndReached: false);

  ListingState<M> withListData(List<M> value, bool endReached) {
    return ListingState(
        tag: STATE_LISTING_LOADED_TAG,
        value: value,
        isLoading: false,
        error: null,
        isPageLoading: false,
        isEndReached: endReached);
  }

  ListingState<M> withLoading() {
    return ListingState(
        tag: STATE_LISTING_LOADING_TAG,
        value: value,
        isLoading: true,
        error: null,
        isPageLoading: false,
        isEndReached: false);
  }

  @override
  ListingState<M> withError(dynamic error) {
    return ListingState(
        tag: STATE_LISTING_LOADING_FAILED_TAG,
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: isEndReached);
  }

  ListingState<M> withPageLoading() {
    return ListingState(
        tag: STATE_LISTING_PAGE_LOADING,
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: true,
        isEndReached: isEndReached);
  }

  ListingState<M> endReached() {
    return ListingState(
        tag: STATE_LISTING_PAGE_LOADING,
        value: value,
        isLoading: false,
        error: error,
        isPageLoading: false,
        isEndReached: true);
  }
}

class ListingBloc<IM extends Mappable>
    extends BaseBloc<MappableList<IM>, ListingState<IM>> {
  final UseCase<void, MappableList<IM>> load;
  final UseCase<MappableList<IM>?, MappableList<IM>> loadMore;

  ListingBloc(
      {required AplRepository<MappableList<IM>> repository,
      required Presenters presenters,
      required this.load,
      required this.loadMore,
      DomainGraph<MappableList<IM>, ListingState<IM>>? customGraph})
      : super(
            initialState: ListingState.initial(),
            repository: repository,
            presenters: presenters,
            customGraph: customGraph);

  @override
  Stream<ListingState<IM>> mapEventToStateImpl(BaseEvents event) async* {
    yield* super.mapEventToStateImpl(event);

    if (event is ScreenCreated) {
      yield currentState.withLoading();
      repository.apply(load, resetOperationsStack: true);
    } else if (event is ScreenOpened) {
      repository.apply(load);
    } else if (event is UpdateRequested) {
      yield currentState.withLoading();
      final isUpdated = await repository.apply(load);
      log("isUpdated: $isUpdated");
    } else if (event is ScrolledToEnd) {
      if (!currentState.isPageLoading) {
        yield currentState.withPageLoading();
        repository.apply(loadMore);
      }
    }
  }
}
