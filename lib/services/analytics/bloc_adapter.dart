import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/logs/extension.dart';

const receiverKey = "receiver";

class BlocEventsAdapter extends BlocsListener {

  final EventBus eventBus;

  BlocEventsAdapter(this.eventBus);

  @override
  void onError(BaseBloc bloc, e) {
    logMethod(methodName: "onError", params: [bloc, e]);
    logError(e);
  }

  @override
  void onNewEvent(BaseBloc bloc, BaseEvents event) {
    logMethod(methodName: "onNewEvent", params: [bloc, event]);
    eventBus.onNewEvent(name: event.name, params: event.params..[receiverKey] = bloc);
  }

  @override
  void onNewState(BaseBloc bloc, BaseState state) {
    logMethod(methodName: "onNewState", params: [bloc, state]);
  }
}