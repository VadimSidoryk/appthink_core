import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/router/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseEvents extends Trackable {
  @override
  final String analyticTag;

  BaseEvents(this.analyticTag);

  @override
  Map<String, Object> get analyticParams => {};

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
  Map<String, Object> get analyticParams => {"source": source};
}

abstract class BaseState {
  final dynamic error;

  BaseState(this.error);

  BaseState withError(dynamic error);
}

abstract class BaseBloc<State extends BaseState>
    extends Bloc<BaseEvents, State> {

  BaseBloc(State initialState) : super(initialState);

  @override
  Stream<State> mapEventToState(BaseEvents event) async* {
    try {
      if (BlocSupervisor.listener != null) {
        BlocSupervisor.listener.onNewEvent(this, event);
      }

      yield* mapEventToStateImpl(event).map((data) {
        if (BlocSupervisor.listener != null) {
          BlocSupervisor.listener.onNewState(this, data);
        }
        return data;
      }).handleError((e) {
        if (BlocSupervisor.listener != null) {
          BlocSupervisor.listener.onError(this, e);
        }
      });
    } catch (e) {
      if (BlocSupervisor.listener != null) {
        BlocSupervisor.listener.onError(this, e);
      }
      yield state.withError(e);
    }
  }

  Stream<State> mapEventToStateImpl(BaseEvents event);
}
