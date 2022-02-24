import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

abstract class AplBlocScreenState<W extends StatefulWidget, E extends WidgetEvents,
    S extends BaseState> extends AplScreenState<W> implements EventsListener<E> {
  AplBloc<S>? _bloc;

  AplBloc<S> createBloc(BuildContext context);

  Widget createWidget(BuildContext context, S state);

  @override
  void initState() {
    super.initState();
    _bloc = createBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        buildWhen: shouldRedrawScreen,
        builder: (context, state) => createWidget(context, state as S));
  }

  @override
  void onEvent(E event) {
    onEventImpl(event);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.close();
  }


  @override
  @protected
  void onEventImpl(WidgetEvents event) {
    super.onEventImpl(event);
    _bloc?.add(event);
  }

  @protected
  bool shouldRedrawScreen(S oldState, S newState) {
    return oldState.runtimeType != newState.runtimeType;
  }


  @protected
  Stream<T> stateStream<T>() {
    return _bloc!.stream
        .where((it) => it is T)
        .map((it) => it as T);
  }


}

extension SendUtils<W extends StatefulWidget, E extends WidgetEvents,
    S extends BaseState> on AplBlocScreenState<W, E, S> {
  @protected
  Function() send0(E Function() eventFactory) => () {
        final event = eventFactory.call();
        onEvent(event);
      };

  @protected
  Function(T) send1<T>(E Function(T) eventFactory) => (arg) {
        final event = eventFactory.call(arg);
        onEvent(event);
      };

  @protected
  Function(T1, T2) send2<T1, T2>(E Function(T1, T2) eventFactory) =>
      (arg1, arg2) {
        final event = eventFactory.call(arg1, arg2);
        onEvent(event);
      };

  @protected
  Function(T1, T2, T3) send3<T1, T2, T3>(E Function(T1, T2, T3) eventFactory) =>
      (arg1, arg2, arg3) {
        final event = eventFactory.call(arg1, arg2, arg3);
        onEvent(event);
      };
}
