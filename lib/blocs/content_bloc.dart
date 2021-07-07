import 'dart:async';
import 'dart:html';

import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core/events/action.dart';
import 'package:flutter/material.dart';

class ContentBloc<VM> extends BaseBloc<ContentState<VM>> {
  final ContentRepository<VM> _repository;

  StreamSubscription? _subscription;

  ContentBloc(this._repository, Presenters presenters)
      : super(ContentState.initial(), presenters) {
    _subscription = _repository.updatesStream.listen((data) {
      add(DisplayData(data));
    });
  }

  @override
  Stream<ContentState<VM>> mapEventToStateImpl(BaseEvents event) async* {
    if (event is Shown) {
      _repository.updateData(false);
    } else if (event is UpdateRequested) {
      yield currentState.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      log("isUpdated: $isUpdated");
      yield currentState.withLoading(false);
    } else if (event is DisplayData<VM>) {
      yield currentState.withValue(event.data);
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}

abstract class BaseContentEvents extends BaseEvents {
  @override
  final String name;

  @override
  Map<String, Object> get params => {};

  BaseContentEvents(this.name) : super(name);
}

class UpdateRequested extends BaseContentEvents {
  UpdateRequested() : super("screen_update");
}

class DisplayData<T> extends BaseContentEvents {
  final T data;

  DisplayData(this.data) : super("data_updated");
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
