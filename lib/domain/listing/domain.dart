import 'package:applithium_core/domain/content/domain.dart';
import 'package:applithium_core/unions/union_4.dart';
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

abstract class ListingScreenState<IM> extends BaseState<List<IM>>
    with Union4<ListLoading, DisplayList, ListPageLoading, ListLoadingFailed> {
  ListingScreenState(String tag) : super(tag);

  factory ListingScreenState.initial() => ListLoading._();

  @override
  BaseState withError(error) => ListLoadingFailed._(error);
}

class ListLoadingFailed<IM> extends ListingScreenState<IM> {
  final dynamic error;

  ListLoadingFailed._(this.error) : super(STATE_LISTING_LOADING_FAILED_TAG);
}

class ListLoading<IM> extends ListingScreenState<IM> {
  ListLoading._() : super(STATE_LISTING_LOADING_TAG);

  ListingScreenState<IM> withData(List<IM> list) => DisplayList._(list);
}

abstract class HasList<IM> extends ListingScreenState<IM> {
  final List<IM> list;
  final bool isPageLoading;

  HasList(
      {required this.list, required this.isPageLoading, required String tag})
      : super(tag);

  ListingScreenState<IM> forceUpdate() => ListLoading._();
}

class DisplayList<IM> extends HasList<IM> {
  DisplayList._(List<IM> list)
      : super(list: list, isPageLoading: false, tag: STATE_LISTING_LOADED_TAG);

  HasList<IM> pageLoading() => ListPageLoading._(list);
}

class ListPageLoading<IM> extends HasList<IM> {
  ListPageLoading._(List<IM> list)
      : super(list: list, isPageLoading: true, tag: STATE_LISTING_PAGE_LOADING);
}

DomainGraph<List<IM>, ListingScreenState<IM>> createListingGraph<IM>(
        UseCase<void, List<IM>> load, UseCase<List<IM>, List<IM>> loadMore) =>
    (state, event) {

  state.fold(
      (listLoading) => event.fold
      (displayList) => event,
      (pageLoading) => event
        (failed) =>
  );
      if (event is WidgetCreated) {
        return DomainGraphEdge(
            newState: ListLoading(), sideEffect: SideEffect.init(load));
      } else if (event is WidgetShown) {
        return DomainGraphEdge(sideEffect: SideEffect.change(load));
      } else if (event is UpdateRequested) {
        return DomainGraphEdge(
            newState: ListLoading(), sideEffect: SideEffect.change(load));
      } else if (event is ScrolledToEnd) {
        if (state is HasList<IM>) {
          final list = (state as HasList<IM>).list;
          return DomainGraphEdge(
              newState: ListPageLoading(list),
              sideEffect: SideEffect.change(loadMore));
        }
      } else if (event is ModelUpdated) {
        return DomainGraphEdge(newState: DisplayList(event.data));
      }
    };
