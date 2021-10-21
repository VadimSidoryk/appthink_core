import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/states.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';

typedef BlocBuilder<S extends BaseState> = Bloc<WidgetEvents, S> Function(
    BuildContext);
typedef WidgetWithStateBuilder<S extends BaseState> = Widget Function(S);

abstract class StateWithBloc<W extends StatefulWidget, S extends BaseState>
    extends State<W> implements EventsListener {

  static StateWithBloc<W, S>
  fromBuilders<W extends StatefulWidget, S extends BaseState>(
      BlocBuilder<S> blocBuilder, WidgetWithStateBuilder<S> widgetBuilder) {
    return _UtilStateWithBloc(blocBuilder, widgetBuilder);
  }

  static StateWithBloc<W, S>
  fromBloc<W extends StatefulWidget, S extends BaseState>(
      Bloc<WidgetEvents, S> bloc, WidgetWithStateBuilder<S> widgetBuilder) {
    return _UtilStateWithBloc((context) => bloc, widgetBuilder);
  }

  late final Bloc<WidgetEvents, S> _bloc;

  @override
  void initState() {
    _bloc = createBloc(context)..add(BaseWidgetEvents.widgetCreated(widget));
    super.initState();
  }

  @protected
  Bloc<WidgetEvents, S> createBloc(BuildContext context);

  @protected
  Widget createWidgetForState(S state);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Bloc<WidgetEvents, S>, S>(
      bloc: _bloc,
      builder: (context, state) => createWidgetForState(state),
      listener: (context, state) {},
    );
  }

  @override
  void onNewEvent(AplEvent event) {
    context.get<EventBus>().onNewEvent(event);
    if (event is WidgetEvents) {
      _bloc.add(event);
    }
  }
}

class _UtilStateWithBloc<W extends StatefulWidget, S extends BaseState>
    extends StateWithBloc<W, S> {
  final BlocBuilder<S> blocBuilder;
  final WidgetWithStateBuilder<S> widgetBuilder;

  _UtilStateWithBloc(this.blocBuilder, this.widgetBuilder);

  @override
  Bloc<WidgetEvents, S> createBloc(BuildContext context) {
    return blocBuilder.call(context);
  }

  @override
  Widget createWidgetForState(S state) {
    return widgetBuilder.call(state);
  }
}
