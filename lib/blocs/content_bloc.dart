import 'dart:async';

import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentBloc<VM, Event extends BaseContentEvent> extends Bloc<BaseContentEvent, ContentState<VM>> {

  final ContentRepository<VM> _repository;
  
  @protected
  final Logger logger;

  StreamSubscription _subscription;

  ContentBloc(this._repository, { this.logger = const DefaultLogger("ContentBloc") }) : super(ContentState(null, true, null)) {
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
      logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if(event is DisplayData<VM>) {
      yield state.withValue(event.data);
    } else {
      yield* mapCustomEventToState(event);
    }
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

 class ContentState<T> extends Trackable {
  final T value;
  final bool isLoading;
  final dynamic error;

  ContentState(this.value, this.isLoading, this.error);

  ContentState<T> withValue(T value) {
    return ContentState(value, false, null);
  }

  ContentState<T> withLoading(bool isLoading) {
    return ContentState(value, isLoading, null);
  }

  ContentState withError(dynamic error) {
    return ContentState(value, false, error);
  }

  @override
  Map<String, Object> get analyticParams => {
    "model" : value,
    "isLoading" : isLoading,
    "error" : error
  };

  @override
  String get analyticTag => "on_new_state";
}


