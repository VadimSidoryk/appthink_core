import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/value_repository.dart';
import 'package:applithium_core/usecases/base.dart';

class ContentBloc<T> extends BaseBloc<ContentState, ContentRepository> {
  ContentBloc(
      {required Presenters presenters,
      required ContentRepository repository,
      required Map<String, UseCase<T>> domain})
      : super(
            initialState: ContentState.initial(),
            presenters: presenters,
            repository: repository,
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

class ContentState extends BaseState {
  final Map<String, dynamic>? value;
  final bool isLoading;

  ContentState(this.value, this.isLoading, error) : super(error);

  factory ContentState.initial() => ContentState(null, true, null);

  ContentState withValue(Map<String, dynamic> value) {
    return ContentState(value, false, null);
  }

  ContentState withLoading(bool isLoading) {
    return ContentState(value, isLoading, null);
  }

  ContentState withError(dynamic error) {
    return ContentState(value, false, error);
  }
}
