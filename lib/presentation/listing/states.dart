import 'package:applithium_core/domain/listing/model.dart';

import '../states.dart';

const STATE_LISTING_LOADING_TAG = "list_loading";
const STATE_LISTING_LOADING_FAILED_TAG = "list_loading_failed";
const STATE_LISTING_LOADED_TAG = "list_loaded";
const STATE_LISTING_PAGE_LOADING = "list_page_loading";
const STATE_LISTING_PAGE_LOADING_FAILED = "list_page_loading_failed";
const STATE_LISTING_EMPTY = "list_empty";
const STATE_LIST_UPDATING = "list_updating";

abstract class ListingScreenState<IM, M extends BaseListModel<IM>>
    extends BaseState<M> {
  ListingScreenState._(String tag) : super(tag);

  factory ListingScreenState.initial() => ListLoadingState._();

  @override
  ListingScreenState<IM, M> withError(error) => ListLoadingFailedState._(error);

  ListingScreenState<IM, M> withData(M data) {
    if (data.items.length > 0) {
      return ListDisplayingState._(data);
    } else {
      return ListEmptyState._(data);
    }
  }
}

class ListLoadingFailedState<IM, M extends BaseListModel<IM>>
    extends ListingScreenState<IM, M> {
  final dynamic error;

  ListLoadingFailedState._(this.error)
      : super._(STATE_LISTING_LOADING_FAILED_TAG);

  ListingScreenState<IM, M> reload() => ListLoadingState._();
}

class ListLoadingState<IM, M extends BaseListModel<IM>>
    extends ListingScreenState<IM, M> {
  ListLoadingState._() : super._(STATE_LISTING_LOADING_TAG);
}

abstract class HasList<IM, M extends BaseListModel<IM>>
    extends ListingScreenState<IM, M> {
  final M data;

  HasList({required this.data, required String tag}) : super._(tag);

  ListingScreenState<IM, M> reload() => ListLoadingState._();
}

class ListDisplayingState<IM, M extends BaseListModel<IM>> extends HasList<IM, M> {
  ListDisplayingState._(M data) : super(data: data, tag: STATE_LISTING_LOADED_TAG);

  ListingScreenState<IM, M> pageLoading() => ListPageLoadingState._(data);

  ListingScreenState<IM, M> update() => ListUpdatingState._(data);
}

class ListPageLoadingState<IM, M extends BaseListModel<IM>> extends HasList<IM, M> {
  ListPageLoadingState._(M data)
      : super(data: data, tag: STATE_LISTING_PAGE_LOADING);

  HasList<IM, M> update() => ListUpdatingState._(data);
}

class ListEmptyState<IM, M extends BaseListModel<IM>> extends HasList<IM, M> {
  ListEmptyState._(M data) : super(data: data, tag: STATE_LISTING_EMPTY);

  ListingScreenState<IM, M> update() => ListUpdatingState._(data);
}

class ListUpdatingState<IM, M extends BaseListModel<IM>> extends HasList<IM, M> {
  ListUpdatingState._(M data) : super(data: data, tag: STATE_LIST_UPDATING);
}
