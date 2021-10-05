import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';

import 'events.dart';

abstract class StateWithBloc<W extends StatefulWidget, S extends BaseState> extends State<W>
    implements EventsListener {
  late final Bloc<WidgetEvents, S> _bloc;

  @override
  void initState() {
    _bloc = createBloc(context)
      ..add(BaseWidgetEvents.widgetCreated(widget));
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
      listener: (context, state) {
      },
    );
  }

  @override
  void onNewEvent(AppEvent event) {
    context.get<EventBus>().onNewEvent(event);
    if (event is WidgetEvents) {
      _bloc.add(event);
    }
  }
}
