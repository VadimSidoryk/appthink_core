import 'dart:async';

import 'package:applithium_core/domain/content/bloc.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/list/load_more.dart';

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

class ListingState<M> extends BaseState<List<M>> {
  final bool isPageLoading;

  ListingState._(
      {required String tag,
      List<M>? value,
      dialogModel,
      this.isPageLoading = false})
      : super(tag);

  factory ListingState.initial() =>
      ListingState._(tag: STATE_LISTING_INITIAL_TAG);

  @override
  BaseState withError(error) => ListLoadingFailed(error);
}

class ListLoadingFailed<M> extends ListingState<M> {
  final dynamic error;
  ListLoadingFailed(this.error) : super._(tag: STATE_LISTING_LOADING_FAILED_TAG);
}

class ListLoading<M> extends ListingState<M> {
  ListLoading(): super._(tag: STATE_LISTING_LOADING_TAG);
}

abstract class HasList<M> {
  List<M> get list;
}

class ListChanged<M> extends ListingState<M> implements HasList<M> {

  final List<M> list;

  ListChanged(this.list) : super._(tag: STATE_LISTING_LOADED_TAG);
}

class ListPageLoading<M> extends ListingState<M> implements HasList<M> {
  final List<M> list;

  ListPageLoading(this.list): super._(tag: STATE_LISTING_PAGE_LOADING, isPageLoading: true);
}

class ListingBloc<IM> extends BaseBloc<List<IM>, ListingState<IM>> {
  final UseCase<void, List<IM>> load;
  final UseCase<List<IM>, List<IM>> loadMore;

  ListingBloc(
      {required AplRepository<List<IM>> repository,
      required Presenters presenters,
      required this.load,
      required this.loadMore,
      DomainGraph<List<IM>, ListingState<IM>>? customGraph})
      : super(
            initialState: ListingState.initial(),
            repository: repository,
            presenters: presenters,
            customGraph: customGraph);

  @override
  Stream<ListingState<IM>> mapEventToStateImpl(BaseEvents event) async* {
    yield* super.mapEventToStateImpl(event);

    if (event is ScreenCreated) {
      yield ListLoading();
      repository.applyInitial(load);
    } else if (event is ScreenOpened) {
      repository.apply(load);
    } else if (event is UpdateRequested) {
      yield ListLoading();
      final isUpdated = await repository.apply(load);
      log("isUpdated: $isUpdated");
    } else if (event is ScrolledToEnd) {
      if (!currentState.isPageLoading) {
        yield ListPageLoading(repository.currentData!);
        repository.apply(listLoadMoreItems(loadMore));
      }
    } else if (event is ModelUpdated) {
      yield ListChanged(event.data);
    }
  }
}
