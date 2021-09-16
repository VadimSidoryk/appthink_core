import 'package:applithium_core/domain/listing/model.dart';
import 'package:applithium_core/unions/union_5.dart';

import '../base_bloc.dart';

const STATE_LISTING_INITIAL_TAG = "list_initial";
const STATE_LISTING_LOADING_TAG = "list_loading";
const STATE_LISTING_LOADING_FAILED_TAG = "list_loading_failed";
const STATE_LISTING_LOADED_TAG = "list_loaded";
const STATE_LISTING_PAGE_LOADING = "list_page_loading";
const STATE_LISTING_PAGE_LOADED = "list_page_loaded";
const STATE_LISTING_PAGE_LOADING_FAILED = "list_page_loading_failed";
const STATE_LISTING_SCROLLED_TO_END = "scrolled_to_end";

abstract class ListingScreenState<IM, M extends WithList<IM>> extends BaseState<M>
    with Union5<ListLoadingState, DisplayListState, ListPageLoadingState, ListLoadingFailedState, EndReachedState> {
  ListingScreenState(String tag) : super(tag);

  factory ListingScreenState.initial() => ListLoadingState._();

  @override
  ListingScreenState<IM, M> withError(error) => ListLoadingFailedState._(error);

  ListingScreenState<IM, M> withData(M data) => DisplayListState._(data);
}

class ListLoadingFailedState<IM, M extends WithList<IM>> extends ListingScreenState<IM, M> {
  final dynamic error;

  ListLoadingFailedState._(this.error) : super(STATE_LISTING_LOADING_FAILED_TAG);

  ListingScreenState<IM, M> reload() => ListLoadingState._();
}

class ListLoadingState<IM, M extends WithList<IM>> extends ListingScreenState<IM, M> {
  ListLoadingState._() : super(STATE_LISTING_LOADING_TAG);
}

abstract class _HasData<IM, M extends WithList<IM>> extends ListingScreenState<IM, M> {
  final M data;

  _HasData(
      {required this.data, required String tag})
      : super(tag);

  ListingScreenState<IM, M> reload() => ListLoadingState._();
}

class DisplayListState<IM, M extends WithList<IM>> extends _HasData<IM, M> {
  DisplayListState._(M data)
      : super(data: data, tag: STATE_LISTING_LOADED_TAG);

  ListingScreenState<IM, M> pageLoading() => ListPageLoadingState._(data);
}

class ListPageLoadingState<IM, M extends WithList<IM>> extends _HasData<IM, M> {
  ListPageLoadingState._(M data)
      : super(data: data, tag: STATE_LISTING_PAGE_LOADING);

  ListingScreenState<IM, M> endReached() => EndReachedState._(data);
}

class EndReachedState<IM, M extends WithList<IM>> extends _HasData<IM, M> {
  EndReachedState._(M data): super(data: data, tag: STATE_LISTING_SCROLLED_TO_END);

  ListingScreenState<IM, M> pageLoading() => ListPageLoadingState._(data);
}