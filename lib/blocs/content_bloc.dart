import 'dart:async';

import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core/router/route.dart';
import 'package:applithium_core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentBloc<Event extends BaseContentEvent, VM> extends Bloc<BaseContentEvent, ContentState<VM>> {

  @protected
  final AplRouter router;

  final ContentRepository<VM> _repository;

  StreamSubscription _subscription;

  ContentBloc(this.router, this._repository) : super(ContentState.initial()) {
   _subscription = _repository.updatesStream.listen((data) {
      add(DisplayData(data));
    });
  }

  @protected
  Stream<ContentState<VM>> mapCustomEventToState(Event event) async* { }

  @override
  Stream<ContentState<VM>> mapEventToState(BaseContentEvent event) async* {
    if(event is Shown) {
      _repository.updateData(false);
    } else if(event is UpdateRequested) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if(event is DisplayData<VM>) {
      yield state.withValue(event.data);
    }  else {
      yield* mapCustomEventToState(event);
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription.cancel();
  }
}

abstract class BaseContentEvent extends Trackable {
  @override
  final String analyticTag;

  @override
  Map<String, Object> get analyticParams => {};

  BaseContentEvent(this.analyticTag);
}

class Shown extends BaseContentEvent {
  Shown(): super("screen_shown");
}

class UpdateRequested extends BaseContentEvent {
  UpdateRequested(): super("screen_update");
}

class DisplayData<T> extends BaseContentEvent {
  final T data;

  DisplayData(this.data): super("data_updated");
}

class OnDialogResult<VM, R> extends BaseContentEvent {
  final VM source;
  final bool isPositiveResult;
  final R result;

  OnDialogResult(this.source, this.isPositiveResult, this.result): super(isPositiveResult ? "dialog_accepted" : "dialog_dismissed");

  @override
  Map<String, Object> get analyticParams => {
    "source" : source
  };
}

 class ContentState<T> {
  final T value;
  final bool isLoading;
  final dynamic error;
  final dynamic dialogModel;

  ContentState(this.value, this.isLoading, this.error, this.dialogModel);

  factory ContentState.initial() => ContentState(null, true, null, null);

  ContentState<T> withValue(T value) {
    return ContentState(value, false, null, null);
  }

  ContentState<T> withRoute(AplRoute route) {
    return ContentState(value, false, null, null);
  }

  ContentState<T> withLoading(bool isLoading) {
    return ContentState(value, isLoading, null, null);
  }

  ContentState<T> withError(dynamic error) {
    return ContentState(value, false, error, null);
  }

  ContentState<T> showDialog(dynamic dialogModel) {
    return ContentState(value, false, null, dialogModel);
  }

  ContentState<T> hideDialog() {
    return ContentState(value, false, null, null);
  }
}


