import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/supervisor.dart';

const KEY_SENDER = "sender";

class BlocEventsAdapter extends BlocsListener {

  final EventBus eventBus;

  BlocEventsAdapter(this.eventBus);

  @override
  void onError(BaseBloc bloc, e) {
    logMethod(methodName: "onError", params: [bloc, e]);
    logError(e);
  }

  @override
  void onNewEvent(BaseBloc bloc, AplEvent event) {
    logMethod(methodName: "onNewEvent", params: [bloc, event]);
    eventBus.onNewEvent(event..params[KEY_SENDER] = bloc);
  }

  @override
  void onNewState(BaseBloc bloc, BaseState state) {
    logMethod(methodName: "onNewState", params: [bloc, state]);
  }
}