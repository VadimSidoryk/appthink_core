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

  final bool isLoading;

  ContentState._({required String tag, dynamic error, M? value, this.isLoading = false}): super(
    tag: tag, error: error, value: value
  );

  factory ContentState.initial() => ContentState._(tag: STATE_CONTENT_INITIAL);

  @override
  ContentState withError(dynamic error) => Failed(error);
}

class Loading<M> extends ContentState<M> {
  Loading(): super._(tag: STATE_CONTENT_LOADING, isLoading: true);
}

class ContentChanged<M> extends ContentState<M> {
  ContentChanged(M data): super._(tag: STATE_CONTENT_LOADED, value: data);
}

class Failed<M> extends ContentState<M> {
  Failed(dynamic error): super._(tag: STATE_CONTENT_ERROR, error: error);
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
      yield Loading();
      repository.applyInitial(load);
    } else if(event is ScreenOpened) {
      repository.apply(load);
    } else if(event is UpdateRequested) {
      yield Loading();
      final isUpdated = await repository.apply(load, resetOperationsStack: true);
      log("isUpdated: $isUpdated");
    } else if(event is ModelUpdated<M>) {
      yield ContentChanged(event.data);
    }
  }
}
