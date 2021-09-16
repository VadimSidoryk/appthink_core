import 'dart:async';

import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/unions/union_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'graph.dart';

abstract class WidgetEvents extends AppEvent {
  WidgetEvents(String name, [Map<String, Object>? params])
      : super(name, params);
}

class BaseWidgetEvents<M> extends WidgetEvents with Union3<WidgetCreatedEvent, WidgetShownEvent, RepositoryUpdatedEvent> {
  BaseWidgetEvents._(String name, [Map<String, Object>? params]) : super(name, params);

  factory BaseWidgetEvents.widgetShown(String name) => WidgetShownEvent._(name);

  factory BaseWidgetEvents.repositoryUpdated(M data) => RepositoryUpdatedEvent._(data);
}

class WidgetCreatedEvent<M> extends BaseWidgetEvents<M> {
  final String screenName;

  WidgetCreatedEvent._(this.screenName)
      : super._("widget_created", {"screen_name": screenName});
}

class WidgetShownEvent<M> extends BaseWidgetEvents<M> {
  final String screenName;

  WidgetShownEvent._(this.screenName)
      : super._("widget_shown", {"screen_name": screenName});
}

class RepositoryUpdatedEvent<M> extends BaseWidgetEvents<M> {
  final M data;

  RepositoryUpdatedEvent._(this.data)
      : super._("repository_updated", {"data": data.toString()});
}

abstract class BaseState<M> {
  final String tag;

  BaseState(this.tag);

  BaseState<M> withError(dynamic error);

  BaseState<M> withData(M data);
}


class AplBloc<E extends WidgetEvents, M, S extends BaseState<M>> extends Bloc<WidgetEvents, S> {
  final AplRepository<M> repository;
  final DomainGraph<E, M, S> domainGraph;

  StreamSubscription? _subscription;

  @protected
  S get currentState => state;

  AplBloc({required S initialState,
    required this.repository,
    required this.domainGraph})
      : super(initialState) {
    _subscription = repository.updatesStream.listen((data) {
      add(RepositoryUpdatedEvent._(data));
    });
  }

  @override
  Stream<S> mapEventToState(WidgetEvents event) async* {
    try {
      BlocSupervisor.listener?.onNewEvent(this, event);

      final stateProvider;
      if(event is E) {
        stateProvider = useDomainGraph(event);
      } else {
        stateProvider = handleBaseEvents(event);
      }

      yield* stateProvider.map((data) {
        BlocSupervisor.listener?.onNewState(this, data);
        return data;
      }).handleError((e) {
        BlocSupervisor.listener?.onError(this, e);
      });
    } catch (e) {
      BlocSupervisor.listener?.onError(this, e);
      yield state.withError(e) as S;
    }
  }

  @protected
  Stream<BaseState<M>> handleBaseEvents(WidgetEvents event) async* {
    if (event is RepositoryUpdatedEvent<M>) {
      yield state.withData(event.data);
    }
  }

  @protected
  Stream<S> useDomainGraph(E event) async* {
    final edge = domainGraph.call(currentState, event);

    if (edge != null) {
      if (edge.nextState != null) {
        yield edge.nextState!;
      } else if (edge.sideEffect != null) {
        final sideEffectApplied = await edge.sideEffect!.apply(repository);
        sideEffectApplied.forEach((applied) async* {
          if (applied && edge.resultStateOnSuccess != null) {
            yield edge.resultStateOnSuccess!.call();
          }

          if (!applied && edge.resultStateOnCancel != null) {
            yield edge.resultStateOnCancel!.call();
          }
        }, (error) async* {
          if (edge.resultStateOnError != null) {
            yield edge.resultStateOnError!.call(error);
          }
        });
      }
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}
