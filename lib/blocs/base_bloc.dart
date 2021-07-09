import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/services/analytics/trackable.dart';
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

abstract class BaseBloc<State extends BaseState>
    extends Bloc<AplEvent, BaseState> {

  final Presenters _presenters;

  @protected
  State get currentState => state as State;

  BaseBloc(State initialState, this._presenters) : super(initialState);

  void showDialog(String path) async {
    final result = await _presenters.dialogPresenter.call(path);
    add(AplEvent.dialogClosed(path, result));
  }

  void showToast(String path) {
    _presenters.toastPresenter.call(path);
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

  Stream<State> mapEventToStateImpl(AplEvent event);
}
