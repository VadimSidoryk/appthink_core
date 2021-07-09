import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/events/action.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:flutter/material.dart';

class ContentBloc<VM> extends BaseBloc<ContentState<VM>> {
  final ContentRepository<VM> _repository;

  StreamSubscription? _subscription;

  ContentBloc(this._repository, Presenters presenters)
      : super(ContentState.initial(), presenters) {
    _subscription = _repository.updatesStream.listen((data) {
      add(AplEvent.displayData(data));
    });
  }

  @override
  Stream<ContentState<VM>> mapEventToStateImpl(AplEvent event) async* {
    switch(event.name) {
      case EVENT_SHOWN_NAME:
        _repository.updateData(false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withLoading(true);
        final isUpdated = await _repository.updateData(true);
        log("isUpdated: $isUpdated");
        yield currentState.withLoading(false);
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withValue(event.params[EVENT_DATA_UPDATED_ARG_DATA] as VM);
        break;
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}

class ContentState<T> extends BaseState {
  final T? value;
  final bool isLoading;

  ContentState(this.value, this.isLoading, error) : super(error);

  factory ContentState.initial() => ContentState(null, true, null);

  ContentState<T> withValue(T value) {
    return ContentState(value, false, null);
  }

  ContentState<T> withRoute(AplAction route) {
    return ContentState(value, false, null);
  }

  ContentState<T> withLoading(bool isLoading) {
    return ContentState(value, isLoading, null);
  }

  ContentState<T> withError(dynamic error) {
    return ContentState(value, false, error);
  }
}
