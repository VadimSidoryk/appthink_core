import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentBloc<VM, Event extends BaseContentEvent> extends Bloc<Event, ContentState<VM>> {

  final ContentRepository _repository;
  final Logger _logger;

  ContentBloc(this._repository, this._logger) : super(ContentState(null, true, null)) {
    _repository.dataStream.listen((data) {
      add(BaseContentEvent.created());
    });
  }

  @override
  Stream<ContentState<VM>> mapEventToState(Event event) async* {
    if(event is Created) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      _logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if(event is Shown) {
      _repository.updateData(false);
    } else if(event is UpdateRequested) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      _logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if(event is DisplayData<VM>) {
      yield state.withValue(event.data);
    }
  }
}

abstract class BaseContentEvent extends Trackable {
  @override
  final String analyticTag;

  @override
  Map<String, Object> get analyticParams => {};

  BaseContentEvent(this.analyticTag);

  factory BaseContentEvent.created() = Created;
  factory BaseContentEvent.shown() = Shown;
  factory BaseContentEvent.updateRequested() = UpdateRequested;
}

class Created extends BaseContentEvent {
  Created(): super("screen_created");
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


