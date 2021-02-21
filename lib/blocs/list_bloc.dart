import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBloc<M extends Equatable, Event extends BaseListEvent>
    extends Bloc<BaseListEvent, ListState<M>> {

  final ListRepository<M> _repository;
  
  @protected
  final Logger logger;

  ListBloc(this._repository, { this.logger = const DefaultLogger("ListBloc") }) : super(  ListState(null, true, false, false, null)) {
    _repository.updatesStream.listen((data) {
      add(DisplayData(data.items, data.isEndReached));
    });
  }

  @protected
  Stream<ListState<M>> mapCustomEventToState(Event event) async* { }

  @override
  Stream<ListState<M>> mapEventToState(BaseListEvent event) async* {
    if (event is Shown) {
      _repository.updateData(false);
    } else if (event is UpdateRequested) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if (event is ScrolledToEnd) {
      _repository.loadMoreItems();
    } else if (event is DisplayData<List<M>>) {
      yield state.withValue(event.data, event.isEndReached);
    } else {
      yield* mapCustomEventToState(event);
    }
  }
}

abstract class BaseListEvent extends Trackable {

  @override
  final String analyticTag;

  @override
  Map<String, Object> get analyticParams => {};

  BaseListEvent(this.analyticTag);
}

class Shown extends BaseListEvent {
  Shown(): super("screen_shown");
}

class UpdateRequested extends BaseListEvent {
  UpdateRequested(): super("screen_update");
}

class DisplayData<T> extends BaseListEvent {
  final T data;
  final isEndReached;

  DisplayData(this.data, this.isEndReached): super("data_updated");
}

class ScrolledToEnd extends BaseListEvent {
  ScrolledToEnd() : super("scrolled_to_end");
}

class ListState<T> {
  final List<T> value;
  final bool isLoading;
  final dynamic error;
  final bool isPageLoading;
  final bool isEndReached;

  ListState(this.value, this.isLoading, this.error, this.isPageLoading, this.isEndReached);

  ListState<T> withValue(List<T> value, bool endReached) {
    return ListState(value, false, null, false, endReached);
  }

  ListState<T> withLoading(bool isLoading) {
    return ListState(value, true, null, false, false);
  }

  ListState withError(dynamic error) {
    return ListState(value, false, error, false, false);
  }

  ListState withPageLoading(bool isPageLoading) {
    return ListState(this.value, false, isPageLoading, false, null);
  }

  ListState endReached() {
    return ListState(this.value, false, false, true, null);
  }
}
