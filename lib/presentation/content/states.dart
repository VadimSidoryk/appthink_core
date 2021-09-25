import '../states.dart';

const STATE_CONTENT_INITIAL = "initial";
const STATE_CONTENT_LOADING = "loading";
const STATE_CONTENT_ERROR = "failed";
const STATE_CONTENT_UPDATING = "updating";
const STATE_CONTENT_LOADED = "loaded";

abstract class ContentScreenState<M> extends BaseState<M> {
  ContentScreenState._(String tag) : super(tag);

  factory ContentScreenState.initial() => ContentLoadingState._();

  ContentScreenState<M> withData(M data) => ContentDisplayingState._(data);

  @override
  ContentScreenState<M> withError(dynamic error) => ContentLoadFailedState._(error);
}

class ContentLoadingState<M> extends ContentScreenState<M> {
  ContentLoadingState._() : super._(STATE_CONTENT_LOADING);
}

class ContentLoadFailedState<M> extends ContentScreenState<M> {
  final dynamic error;

  ContentLoadFailedState._(this.error) : super._(STATE_CONTENT_ERROR);

  ContentScreenState<M> reload() => ContentLoadingState._();
}

abstract class HasContent<M> extends ContentScreenState<M> {
  final M data;
  final bool isUpdating;

  ContentScreenState<M> reload() => ContentLoadingState._();

  HasContent._(
      {required this.data, required this.isUpdating, required String tag})
      : super._(tag);
}

class ContentDisplayingState<M> extends HasContent<M> {
  ContentDisplayingState._(M data)
      : super._(data: data, isUpdating: false, tag: STATE_CONTENT_LOADED);

  HasContent<M> update() => ContentUpdatingState._(this.data);
}

class ContentUpdatingState<M> extends HasContent<M> {
  ContentUpdatingState._(M data)
      : super._(data: data, isUpdating: true, tag: STATE_CONTENT_UPDATING);
}
