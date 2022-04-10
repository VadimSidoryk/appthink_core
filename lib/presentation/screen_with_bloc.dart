import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

abstract class AplBlocScreenState<W extends StatefulWidget,
E extends WidgetEvents, S extends BaseState> extends AplScreenState<W>
    implements EventsListener<E> {
  AplBloc<S>? _bloc;

  AplBloc<S> createBloc(BuildContext context);

  Widget createWidget(BuildContext context, S state);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = createBloc(context);
    }
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
    return _bloc!.stream.where((it) => it is T).map((it) => it as T);
  }
}


