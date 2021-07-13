import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/content/repository.dart';
import 'package:applithium_core/usecases/base.dart';

const STATE_CONTENT_LOADING = "loading";

class ContentState extends BaseState {
  final Map<String, dynamic>? value;
  final bool isLoading;

  ContentState(String tag, this.value, this.isLoading, error)
      : super(tag, error);

  factory ContentState.initial() =>
      ContentState(STATE_BASE_INITIAL_TAG, null, true, null);

  ContentState withValue(Map<String, dynamic> value) {
    return ContentState(STATE_BASE_DATA_TAG, value, false, null);
  }

  ContentState withLoading(bool isLoading) {
    return ContentState(STATE_CONTENT_LOADING, value, isLoading, null);
  }

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
      case EVENT_SHOWN_NAME:
        repository.loadData(false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withLoading(true);
        final isUpdated = await repository.loadData(true);
        log("isUpdated: $isUpdated");
        yield currentState.withLoading(false);
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withValue(
            event.params[EVENT_DATA_UPDATED_ARG_DATA] as Map<String, dynamic>);
        break;
      default:
        yield* super.mapEventToStateImpl(event);
    }
  }
}