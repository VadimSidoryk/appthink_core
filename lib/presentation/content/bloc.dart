import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/content/repository.dart';
import 'package:applithium_core/usecases/base.dart';

const STATE_CONTENT_LOADING = "loading";

class ContentState<T> extends BaseState<T> {
  final bool isLoading;

  ContentState(String tag, T? value, this.isLoading, error)
      : super(tag: tag, error: error, value: value);

  factory ContentState.initial() =>
      ContentState(STATE_BASE_INITIAL_TAG, null, true, null);

  ContentState withData(T value) {
    return ContentState(STATE_BASE_DATA_TAG, value, false, null);
  }

  ContentState withLoading() {
    return ContentState(STATE_CONTENT_LOADING, value, true, null);
  }

  @override
  ContentState withError(dynamic error) {
    return ContentState(STATE_BASE_ERROR_TAG, value, false, error);
  }
}

class ContentBloc<T> extends BaseBloc<ContentState, ContentRepository> {
  ContentBloc(
      {required ContentRepository repository,
      required Presenters presenters,
      required Map<String, UseCase<T>> domain})
      : super(
            initialState: ContentState.initial(),
            repository: repository,
            presenters: presenters,
            domain: domain);

  @override
  Stream<ContentState> mapEventToStateImpl(AplEvent event) async* {
    switch (event.name) {
      case EVENT_CREATED_NAME:
        yield currentState.withLoading();
        repository.loadData(isForced: true);
        break;
      case EVENT_SCREEN_OPENED_NAME:
        repository.loadData(isForced: false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withLoading();
        final isUpdated = await repository.loadData(isForced: true);
        log("isUpdated: $isUpdated");
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withData(
            event.params[EVENT_DATA_UPDATED_ARG_DATA]);
        break;
      default:
        yield* super.mapEventToStateImpl(event);
    }
  }
}
