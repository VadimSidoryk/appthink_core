import 'dart:async';

import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/either/either.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class WidgetEvents extends AppEvent {
  WidgetEvents(String name, [Map<String, Object>? params]) : super(name, params);

  factory WidgetEvents.widgetShown(String name) => WidgetShown._(name);
}

class WidgetShown extends WidgetEvents {
  final String screenName;

  WidgetShown._(this.screenName)
      : super("screen_opened", {"screen_name": screenName});
}

class ModelUpdated<VM> extends WidgetEvents {
  final VM data;

  ModelUpdated._(this.data) : super("data_updated");
}

abstract class BaseState<T> {
  final String tag;

  BaseState(this.tag);

  BaseState withError(dynamic error);
}

class DomainGraphEdge<M, S extends BaseState<M>> {
  final SideEffect<M>? sideEffect;
  final S? Function(Either<bool>)? nextStateProvider;

  DomainGraphEdge({this.sideEffect, this.nextStateProvider});
}

typedef DomainGraph<M, S extends BaseState<M>> = DomainGraphEdge<M, S>?
    Function(S, WidgetEvents);

extension DomainGraphUtils<M, S extends BaseState<M>> on DomainGraph<M, S> {
  DomainGraph<M, S> plus(DomainGraph<M, S> plusGraph) => (state, event) {
        return this.call(state, event) ?? plusGraph.call(state, event);
      };
}

class AplBloc<M, S extends BaseState<M>> extends Bloc<WidgetEvents, S> {
  final AplRepository<M> repository;
  final DomainGraph<M, S>? customGraph;

  StreamSubscription? _subscription;

  @protected
  S get currentState => state;

  AplBloc({required S initialState, required this.repository, this.customGraph})
      : super(initialState) {
    _subscription = repository.updatesStream.listen((data) {
      add(ModelUpdated._(data));
    });
  }

  @override
  Stream<S> mapEventToState(WidgetEvents event) async* {
    try {
      BlocSupervisor.listener?.onNewEvent(this, event);

      yield* mapEventToStateImpl(event).map((data) {
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

  Stream<S> mapEventToStateImpl(WidgetEvents event) async* {
    final edge = customGraph?.call(currentState, event);

    if (edge != null) {
      if (edge.sideEffect != null) {
        final sideEffectApplied = await edge.sideEffect!.apply(repository);
        final futureState = edge.nextStateProvider?.call(sideEffectApplied);
        if (futureState != null) {
          yield futureState;
        }
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
