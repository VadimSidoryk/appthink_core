import 'dart:async';

import 'package:applithium_core/json/mappable.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/repository.dart';
import 'package:applithium_core/usecases/base.dart';

const STATE_CONTENT_INITIAL = "initial";
const STATE_CONTENT_LOADING = "loading";
const STATE_CONTENT_ERROR = "error";
const STATE_CONTENT_WITH_DATA = "display_data";


abstract class BaseContentEvents extends BaseEvents {
  BaseContentEvents(String name) : super(name);

  factory BaseContentEvents.updateRequested() => UpdateRequested._();
}

class UpdateRequested extends BaseContentEvents {
  UpdateRequested._() : super("screen_update");
}

class DisplayData<M extends Mappable> extends BaseContentEvents {
  final M data;

  DisplayData._(this.data) : super("data_updated");
}

class ContentState<M extends Mappable> extends BaseState<M> {
  final bool isLoading;

  ContentState(String tag, M? value, this.isLoading, error)
      : super(tag: tag, error: error, value: value);

  factory ContentState.initial() =>
      ContentState(STATE_CONTENT_INITIAL, null, true, null);

  ContentState<M> withData(M value) {
    return ContentState(STATE_CONTENT_WITH_DATA, value, false, null);
  }

  ContentState<M> withLoading() {
    return ContentState(STATE_CONTENT_LOADING, value, true, null);
  }

  @override
  ContentState<M> withError(dynamic error) {
    return ContentState(STATE_CONTENT_ERROR, value, false, error);
  }
}

class ContentBloc<M extends Mappable> extends BaseBloc<M, ContentState<M>> {
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
      yield currentState.withLoading();
      repository.apply(load, resetOperationsStack: true);
    } else if(event is ScreenOpened) {
      repository.apply(load);
    } else if(event is UpdateRequested) {
      yield currentState.withLoading();
      final isUpdated = await repository.apply(load, resetOperationsStack: true);
      log("isUpdated: $isUpdated");
    } else if(event is ModelUpdated<M>) {
      yield currentState.withData(event.data);
    }
  }
}
