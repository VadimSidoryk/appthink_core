import 'dart:async';

import 'package:applithium_core/presentation/supervisor.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/json/interpolation_args.dart';
import 'package:applithium_core/presentation/base_repository.dart';
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

const STATE_BASE_INITIAL_TAG = "initial";
const STATE_BASE_ERROR_TAG = "error";
const STATE_BASE_DATA_TAG = "data";

const STATE_BASE_ERROR_KEY = "error";

abstract class BaseState extends InterpolationArgs {
  final String tag;
  final dynamic error;

  BaseState(this.tag, this.error);

  BaseState withError(dynamic error);

  @override
  Map<String, dynamic> asArgs() {
    return {
      STATE_BASE_ERROR_KEY: error,
    };
  }
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
      required this.repository,
      required this.domain,
      required this.presenters})
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
      repository.apply(useCase.withEventParams(event.asArgs()));
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}
