import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBloc<VM, Event extends BaseListEvent>
    extends Bloc<Event, ListState<VM>> {

  final ListRepository _repository;
  final Logger _logger;

  ListBloc(this._repository, this._logger) : super(ListState(null, true, false, null)) {
    _repository.dataStream.listen((data) {
      add(BaseListEvent.created());
    });
  }

  @override
  Stream<ListState<VM>> mapEventToState(Event event) async* {
    if (event is Created) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      _logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if (event is Shown) {
      _repository.updateData(false);
    } else if (event is UpdateRequested) {
      yield state.withLoading(true);
      final isUpdated = await _repository.updateData(true);
      _logger.log("isUpdated: $isUpdated");
      yield state.withLoading(false);
    } else if (event is ScrolledToEnd) {
      _repository.loadMoreItems();
    } else if (event is DisplayData<List<VM>>) {
      yield state.withValue(event.data);
    }
  }
}

abstract class BaseListEvent extends Trackable {

  @override
  final String analyticTag;

  @override
  Map<String, Object> get analyticParams => {};

  BaseListEvent(this.analyticTag);

  factory  BaseListEvent.created() = Created;
  factory  BaseListEvent.shown() = Shown;
  factory  BaseListEvent.updateRequested() = UpdateRequested;
  factory  BaseListEvent.scrolledToEnd() = ScrolledToEnd;
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
  ListState(List<VM> value, bool isLoading, bool isPageLoading, dynamic error)
      : super(value, isLoading, error);

  ListState withPageLoading(bool isPageLoading) {
    return ListState(this.value, false, isPageLoading, null);
  }
}
