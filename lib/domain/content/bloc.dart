import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';
import '../repository.dart';

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

  ContentState._({required String tag}): super(tag);

  factory ContentState.initial() => ContentState._(tag: STATE_CONTENT_INITIAL);

  @override
  ContentState withError(dynamic error) => ContentFailed(error);
}

class ContentLoading<M> extends ContentState<M> {
  ContentLoading(): super._(tag: STATE_CONTENT_LOADING);
}

class ContentChanged<M> extends ContentState<M> {

  final M data;

  ContentChanged(this.data): super._(tag: STATE_CONTENT_LOADED);
}

class ContentFailed<M> extends ContentState<M> {

  final dynamic error;

  ContentFailed(this.error): super._(tag: STATE_CONTENT_ERROR);
}

class ContentBloc<M> extends BaseBloc<M, ContentState<M>> {
  final UseCase<void, M> load;

  ContentBloc(
      {required AplRepository<M> repository,
      required Presenters presenters,
      required this.load,
      DomainGraph<M, ContentState<M>>? customGraph})
      : super(
            initialState: ContentState.initial(),
            repository: repository,
            presenters: presenters,
            customGraph: customGraph);

  @override
  Stream<ContentState<M>> mapEventToStateImpl(BaseEvents event) async* {
    yield* super.mapEventToStateImpl(event);

    if(event is ScreenCreated) {
      yield ContentLoading();
      repository.applyInitial(load);
    } else if(event is ScreenOpened) {
      repository.apply(load);
    } else if(event is UpdateRequested) {
      yield ContentLoading();
      final isUpdated = await repository.apply(load, resetOperationsStack: true);
      log("isUpdated: $isUpdated");
    } else if(event is ModelUpdated<M>) {
      yield ContentChanged(event.data);
    }
  }
}
