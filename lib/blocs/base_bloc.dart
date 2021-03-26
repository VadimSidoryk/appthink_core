import 'package:applithium_core/analytics/trackable.dart';
import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/router/route.dart';
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

  factory BaseEvents.dialogClosed(source, isAccepted, result) =>
      DialogClosed._(source, isAccepted, result);
}

class Shown extends BaseEvents {
  Shown._() : super("screen_shown");
}

class DialogClosed<VM, R> extends BaseEvents {
  final VM source;
  final bool isAccepted;
  final R result;

  DialogClosed._(this.source, this.isAccepted, this.result)
      : super(isAccepted ? "dialog_accepted" : "dialog_dismissed");

  @override
  Map<String, Object> get analyticParams => {"source": source};
}

abstract class BaseState {
  final dynamic error;
  final dynamic dialogModel;

  BaseState(this.error, this.dialogModel);

  BaseState withError(dynamic error);

  BaseState showDialog(dynamic dialogVM);

  BaseState hideDialog();
}

abstract class BaseBloc<Event extends BaseEvents, State extends BaseState>
    extends Bloc<Event, State> {

  @protected
  final AplRouter router;

  BaseBloc(this.router, State initialState) : super(initialState);

  @override
  Stream<State> mapEventToState(Event event) async* {
    try {
      if (BlocSupervisor.listener != null) {
        BlocSupervisor.listener.onNewEvent(this, event);
      }
      mapEventToStateImpl(event).map((data) {
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

  Stream<State> mapEventToStateImpl(Event event);
}
