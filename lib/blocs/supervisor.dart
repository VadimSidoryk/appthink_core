import 'package:applithium_core/blocs/base_bloc.dart';

class BlocSupervisor {
  static BlocsListener? listener;
}

abstract class BlocsListener {
  void onNewEvent(BaseBloc bloc, BaseEvents event);

  void onError(BaseBloc bloc, dynamic e);

  void onNewState(BaseBloc bloc, BaseState state);
}