import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSupervisor {
  static BlocsListener delegate;
}

abstract class BlocsListener {
  void onNewEvent(BaseBloc bloc, BaseEvents event);

  void onError(BaseBloc bloc, dynamic e);

  void onNewState(BaseBloc bloc, BaseState state);
}