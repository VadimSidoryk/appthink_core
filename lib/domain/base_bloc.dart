import 'dart:async';

import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/unions/union_3.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DialogPresenter = Future<dynamic> Function(String);
typedef ToastPresenter = void Function(String);

abstract class WidgetEvents extends AppEvent {
  WidgetEvents(String name, [Map<String, Object>? params]) : super(name, params);

  factory WidgetEvents.widgetShown(String name) => WidgetShown._(name);

  factory WidgetEvents.widgetCreated() => WidgetCreated._("undefined");
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

class WidgetCreated extends WidgetEvents {
  final String screenName;

  WidgetCreated._(this.screenName)
      : super(EVENT_CREATED_NAME, {"screen_name": screenName});
}

abstract class BaseState<T> {
  final String tag;

  BaseState(this.tag);

  BaseState withError(dynamic error);
}

abstract class SideEffect<M> with Union3<Init, Change, Send> {
  Future<bool> apply(AplRepository<M> repo);

  factory SideEffect.init(UseCase<void, M> sourceUseCase) =>
      Init._(sourceUseCase);

  factory SideEffect.change(UseCase<M, M> changingUseCase) =>
      Change._(changingUseCase);

  factory SideEffect.send(UseCase<M, void> sendingUseCase) =>
      Send._(sendingUseCase);

  SideEffect._();

}

class Init<M> extends SideEffect<M> {
  final UseCase<void, M> sourceUseCase;

  Init._(this.sourceUseCase): super._();

  @override
  Future<bool> apply(AplRepository<M> repo) {
    return repo.applyInitial(sourceUseCase);
  }
}

class Change<M> extends SideEffect<M> {
  final UseCase<M, M> changingUseCase;

  Change._(this.changingUseCase): super._();

  @override
  Future<bool> apply(AplRepository<M> repo) {
    return repo.apply(changingUseCase);
  }
}

class Send<M> extends SideEffect<M> {
  final UseCase<M, void> sendingUseCase;

  Send._(this.sendingUseCase): super._();

  @override
  Future<bool> apply(AplRepository<M> repo) async {
    final data = repo.currentData;
    if (data == null) {
      return false;
    } else {
      try {
        await sendingUseCase.call(data);
        return true;
      } catch (e) {
        logError("can't sending data", ex: e);
        return false;
      }
    }
  }
}

class DomainGraphEdge<M, S extends BaseState<M>> {
  final S? newState;
  final SideEffect<M>? sideEffect;
  final S? Function(bool)? resultStateProvider;

  DomainGraphEdge({this.newState, this.sideEffect, this.resultStateProvider});
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
      if (edge.newState != null) {
        yield edge.newState!;
      }

      if (edge.sideEffect != null) {
        final sideEffectApplied = await edge.sideEffect!.apply(repository);
        final futureState = edge.resultStateProvider?.call(sideEffectApplied);
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
