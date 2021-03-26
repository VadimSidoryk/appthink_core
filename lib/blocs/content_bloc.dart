import 'dart:async';

import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core/router/route.dart';
import 'package:applithium_core/router/router.dart';
import 'package:flutter/material.dart';

class ContentBloc<Event extends BaseContentEvents, VM> extends BaseBloc<BaseContentEvents, ContentState<VM>> {

  final ContentRepository<VM> _repository;

  StreamSubscription _subscription;

  ContentBloc(router, this._repository) : super(router, ContentState.initial()) {
   _subscription = _repository.updatesStream.listen((data) {
      add(DisplayData(data));
    });
  }

  @override
  Stream<ContentState<VM>> mapEventToStateImpl(BaseContentEvents event) async* {
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

  Stream<ContentState<VM>> mapCustomEventToState(Event event) {}

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription.cancel();
  }
}

abstract class BaseContentEvents extends BaseEvents  {
  @override
  final String analyticTag;

  @override
  Map<String, Object> get analyticParams => {};

  BaseContentEvents(this.analyticTag): super(analyticTag);
}



class UpdateRequested extends BaseContentEvents {
  UpdateRequested(): super("screen_update");
}

class DisplayData<T> extends BaseContentEvents {
  final T data;

  DisplayData(this.data): super("data_updated");
}

class DialogClosed<VM, R> extends BaseContentEvents {
  final VM source;
  final bool isPositiveResult;
  final R result;

  DialogClosed(this.source, this.isPositiveResult, this.result): super(isPositiveResult ? "dialog_accepted" : "dialog_dismissed");

  @override
  Map<String, Object> get analyticParams => {
    "source" : source
  };
}

 class ContentState<T> extends BaseState {
  final T value;
  final bool isLoading;


  ContentState(this.value, this.isLoading, error, dialogModel): super(error, dialogModel);

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


