import 'package:applithium_core/events/base_event.dart';

import '../presentation/base_bloc.dart';

class BlocSupervisor {
  static BlocsListener? listener;
}

abstract class BlocsListener {
  void onNewEvent(AplBloc bloc, AppEvent event);

  void onError(AplBloc bloc, dynamic e);

  void onNewState(AplBloc bloc, BaseState state);
}