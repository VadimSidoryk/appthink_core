import 'package:applithium_core/events/event.dart';

import 'base_bloc.dart';

class BlocSupervisor {
  static BlocsListener? listener;
}

abstract class BlocsListener {
  void onNewEvent(AplBloc bloc, AplEvent event);

  void onError(AplBloc bloc, dynamic e);

  void onNewState(AplBloc bloc, BaseState state);
}