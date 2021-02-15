import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
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

  ListBloc(this._repository, { this.logger = const DefaultLogger() }) : super(  ListState(null, true, false, false, null)) {
    add(Created());
    _repository.updatesStream.listen((data) {
      add(DisplayData(data));
    });
  }

  @protected
  Stream<ListState<M>> mapCustomEventToState(Event event) async* { }

  @override
  Stream<ListState<M>> mapEventToState(BaseListEvent event) async* {
    if (event is Created) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if (event is Shown) {
      _repository.updateData(false);
    } else if (event is UpdateRequested) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if (event is ScrolledToEnd) {
      _repository.loadMoreItems();
    } else if (event is DisplayData<List<M>>) {
      yield state.withValue(event.data);
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

class Created extends BaseListEvent {
  Created(): super("screen_created");
}

class Shown extends BaseListEvent {
  Shown(): super("screen_shown");
}

class UpdateRequested extends BaseListEvent {
  UpdateRequested(): super("screen_update");
}

class DisplayData<T> extends BaseListEvent {
  final T data;

  DisplayData(this.data): super("data_updated");
}

class ScrolledToEnd extends BaseListEvent {
  ScrolledToEnd() : super("scrolled_to_end");
}

class ListState<VM> extends ContentState<List<VM>> {

  final bool isPageLoading;
  final bool isEndReached;
  
  ListState(List<VM> value, bool isLoading, this.isPageLoading, this.isEndReached, dynamic error)
      : super(value, isLoading, error);

  ListState withPageLoading(bool isPageLoading) {
    return ListState(this.value, false, isPageLoading, false, null);
  }

  ListState endReached() {
    return ListState(this.value, false, false, true, null);
  }
}
