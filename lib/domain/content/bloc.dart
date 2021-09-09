
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';

const STATE_CONTENT_INITIAL = "initial";
const STATE_CONTENT_LOADING = "loading";
const STATE_CONTENT_ERROR = "failed";
const STATE_CONTENT_LOADED = "loaded";

abstract class BaseContentEvents extends BaseEvents {
  BaseContentEvents(String name) : super(name);
}

class UpdateRequested extends BaseContentEvents {
  UpdateRequested() : super("screen_update");
}

class DisplayData<M> extends BaseContentEvents {
  final M data;

  DisplayData(this.data) : super("data_updated");
}

class ContentState<M> extends BaseState<M> {
  ContentState._({required String tag}) : super(tag);

  factory ContentState.initial() => ContentState._(tag: STATE_CONTENT_INITIAL);

  @override
  ContentState withError(dynamic error) => ContentFailed(error);
}

class ContentLoading<M> extends ContentState<M> {
  ContentLoading() : super._(tag: STATE_CONTENT_LOADING);
}

class ContentChanged<M> extends ContentState<M> {
  final M data;

  ContentChanged(this.data) : super._(tag: STATE_CONTENT_LOADED);
}

class ContentFailed<M> extends ContentState<M> {
  final dynamic error;

  ContentFailed(this.error) : super._(tag: STATE_CONTENT_ERROR);
}

DomainGraph<M, ContentState<M>> createContentGraph<M> (UseCase<void, M> load) => (state, event) {
  if (event is ScreenCreated) {
    return DomainGraphEdge(newState: ContentLoading(), sideEffect: SideEffect.get(load));
  } else if (event is ScreenOpened) {
    return DomainGraphEdge(sideEffect: SideEffect.change(load));
  } else if (event is UpdateRequested) {
    return DomainGraphEdge(newState: ContentLoading(), sideEffect: SideEffect.change(load));
  } else if (event is ModelUpdated<M>) {
    return DomainGraphEdge(newState: ContentChanged(event.data));
  }
};

