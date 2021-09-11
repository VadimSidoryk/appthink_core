
import 'package:applithium_core/domain/content/domain.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';

const STATE_LISTING_INITIAL_TAG = "list_initial";
const STATE_LISTING_LOADING_TAG = "list_loading";
const STATE_LISTING_LOADING_FAILED_TAG = "list_loading_failed";
const STATE_LISTING_LOADED_TAG = "list_loaded";
const STATE_LISTING_PAGE_LOADING = "list_page_loading";
const STATE_LISTING_PAGE_LOADED = "list_page_loaded";
const STATE_LISTING_PAGE_LOADING_FAILED = "list_page_loading_failed";

abstract class BaseListEvents extends WidgetEvents {
  BaseListEvents(String name) : super(name);
}

class DisplayData<T> extends BaseListEvents {
  final T data;
  final isEndReached;

  DisplayData(this.data, this.isEndReached) : super("data_updated");
}

class ScrolledToEnd extends BaseListEvents {
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

DomainGraph<List<IM>, ListingState<IM>> createListingGraph<IM>(UseCase<void, List<IM>> load, UseCase<List<IM>, List<IM>> loadMore) => (state, event) {
  if (event is WidgetCreated) {
    return DomainGraphEdge(newState: ListLoading(), sideEffect: SideEffect.init(load));
  } else if (event is WidgetShown) {
    return DomainGraphEdge(sideEffect: SideEffect.change(load));
  } else if (event is UpdateRequested) {
    return DomainGraphEdge(newState: ListLoading(), sideEffect: SideEffect.change(load));
  } else if (event is ScrolledToEnd) {
    if (state is HasList<IM>) {
      final list = (state as HasList<IM>).list;
      return DomainGraphEdge(newState: ListPageLoading(list), sideEffect: SideEffect.change(loadMore));
    }
  } else if (event is ModelUpdated) {
    return DomainGraphEdge(newState: ListChanged(event.data));
  }
};


