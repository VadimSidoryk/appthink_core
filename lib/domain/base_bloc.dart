import 'dart:async';

import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DialogPresenter = Future<dynamic> Function(String);
typedef ToastPresenter = void Function(String);

class Presenters {
  final DialogPresenter dialogPresenter;
  final ToastPresenter toastPresenter;

  Presenters({required this.dialogPresenter, required this.toastPresenter});
}

abstract class BaseEvents extends AplEvent {
  BaseEvents(String name, [Map<String, Object>? params]) : super(name, params);

  factory BaseEvents.screenOpened(String name) => ScreenOpened._(name);

  factory BaseEvents.dialogClosed(source, result) =>
      DialogClosed._(source, result);

  factory BaseEvents.screenCreated() => ScreenCreated._("undefined");
}

class ScreenOpened extends BaseEvents {
  final String screenName;

  ScreenOpened._(this.screenName) : super("screen_opened", {"screen_name": screenName});
}

class DialogClosed<VM, R> extends BaseEvents {
  final VM source;
  final R result;

  DialogClosed._(this.source, this.result)
      : super(result != null ? "dialog_accepted" : "dialog_dismissed", {"source": source.toString()});
}

class ModelUpdated<VM> extends BaseEvents {
  final VM data;

  ModelUpdated._(this.data) : super("data_updated");
}

class ScreenCreated extends BaseEvents {
  final String screenName;

  ScreenCreated._(this.screenName) : super(EVENT_CREATED_NAME, {"screen_name": screenName});
}

abstract class BaseState<T> {
  final String tag;

  BaseState(this.tag);

  BaseState withError(dynamic error);
}

abstract class SideEffect<M> {

  Future<bool> apply(AplRepository<M> repo);

  factory SideEffect.change(UseCase<M, M> changingUseCase) => Change._(changingUseCase);

  factory SideEffect.get(UseCase<void, M> sourceUseCase) => Get._(sourceUseCase);
}

class Get<M> implements SideEffect<M> {
  final UseCase<void, M> sourceUseCase;

  Get._(this.sourceUseCase);

  @override
  Future<bool> apply(AplRepository<M> repo) {
    return repo.applyInitial(sourceUseCase);
  }
}

class Change<M> implements SideEffect<M> {

  final UseCase<M, M> changingUseCase;

  Change._(this.changingUseCase);

  @override
  Future<bool> apply(AplRepository<M> repo) {
    return repo.apply(changingUseCase);
  }
}


class DomainGraphEdge<M, S extends BaseState<M>> {
  final S? newState;
  final SideEffect<M>? sideEffect;
  final S? Function(bool)? resultStateProvider;

  DomainGraphEdge({this.newState, this.sideEffect, this.resultStateProvider});
}

typedef DomainGraph<M, S extends BaseState<M>> = DomainGraphEdge<M, S>?
    Function(S, BaseEvents);

extension DomainGraphUtils<M, S extends BaseState<M>> on DomainGraph<M, S> {
  DomainGraph<M,S> plus(DomainGraph<M, S> plusGraph) => (state, event) {
    return this.call(state, event) ?? plusGraph.call(state, event);
  };
}


class AplBloc<M, S extends BaseState<M>>
    extends Bloc<BaseEvents, S> {
  final AplRepository<M> repository;
  final Presenters presenters;
  final DomainGraph<M, S>? customGraph;

  StreamSubscription? _subscription;

  @protected
  S get currentState => state;

  AplBloc(
      {required S initialState,
      required this.repository,
      required this.presenters,
      this.customGraph})
      : super(initialState) {
    _subscription = repository.updatesStream.listen((data) {
      add(ModelUpdated._(data));
    });
  }

  void showDialog(String path) async {
    final result = await presenters.dialogPresenter.call(path);
    add(DialogClosed._(path, result));
  }

  void showToast(String path) {
    presenters.toastPresenter.call(path);
  }

  @override
  Stream<S> mapEventToState(BaseEvents event) async* {
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

  Stream<S> mapEventToStateImpl(BaseEvents event) async* {
    final edge = customGraph?.call(currentState, event);
    if (edge?.newState != null) {
      yield edge!.newState!;
    }

    if (edge?.sideEffect != null) {
      final sideEffectApplied = await edge!.sideEffect!.apply(repository);
      final futureState = edge.resultStateProvider?.call(sideEffectApplied);
      if (futureState != null) {
        yield futureState;
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
