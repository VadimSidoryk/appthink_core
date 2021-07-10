import 'dart:async';

import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/repositories/base_repository.dart';
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

abstract class BaseState {
  final dynamic error;

  BaseState(this.error);

  BaseState withError(dynamic error);
}

class BaseBloc<S extends BaseState, R extends BaseRepository>
    extends Bloc<AplEvent, BaseState> {
  final R repository;
  final Map<String, UseCase> domain;
  final Presenters presenters;

  StreamSubscription? _subscription;

  @protected
  S get currentState => state as S;

  BaseBloc(
      {required S initialState,
      required this.presenters,
      required this.repository,
      required this.domain})
      : super(initialState) {
    _subscription = repository.updatesStream.listen((data) {
      add(AplEvent.displayData(data));
    });
  }

  void showDialog(String path) async {
    final result = await presenters.dialogPresenter.call(path);
    add(AplEvent.dialogClosed(path, result));
  }

  void showToast(String path) {
    presenters.toastPresenter.call(path);
  }

  @override
  Stream<BaseState> mapEventToState(AplEvent event) async* {
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
      yield state.withError(e);
    }
  }

  Stream<S> mapEventToStateImpl(AplEvent event) async* {
    if (domain.containsKey(event.name)) {
      final useCase = domain[event.name] as UseCase;
      repository.apply(useCase.withParams(event.params));
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}
