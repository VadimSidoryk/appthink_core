import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/events/event.dart';

class BlocSupervisor {
  static BlocsListener? listener;
}

abstract class BlocsListener {
  void onNewEvent(BaseBloc bloc, AplEvent event);

  void onError(BaseBloc bloc, dynamic e);

  void onNewState(BaseBloc bloc, BaseState state);
}