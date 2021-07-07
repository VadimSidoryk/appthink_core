import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/services/analytics/trackable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DialogBuilder = Future<dynamic> Function(String);
typedef ToastBuilder = void Function(String);

abstract class BaseEvents extends Trackable {
  @override
  final String name;

  BaseEvents(this.name);

  @override
  Map<String, Object> get params => {};

  factory BaseEvents.screenShown() => Shown._();

  factory BaseEvents.dialogClosed(source, result) =>
      DialogClosed._(source, result);
}

class Shown extends BaseEvents {
  Shown._() : super("screen_shown");
}

class DialogClosed<VM, R> extends BaseEvents {
  final VM source;
  final R result;

  DialogClosed._(this.source, this.result)
      : super(result != null ? "dialog_accepted" : "dialog_dismissed");

  @override
  Map<String, Object> get params => {"source": source.toString()};
}

abstract class BaseState {
  final dynamic error;

  BaseState(this.error);

  BaseState withError(dynamic error);
}

abstract class BaseBloc<State extends BaseState>
    extends Bloc<BaseEvents, BaseState> {

  final DialogBuilder _dialogBuilder;
  final ToastBuilder _toastBuilder;

  @protected
  State get currentState => state as State;

  BaseBloc(State initialState, this._dialogBuilder, this._toastBuilder) : super(initialState);

  void showDialog(String path) async {
    final result = await _dialogBuilder.call(path);
    add(BaseEvents.dialogClosed(path, result));
  }

  void showToast(String path) {
    _toastBuilder.call(path);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvents event) async* {
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

  Stream<State> mapEventToStateImpl(BaseEvents event);
}
