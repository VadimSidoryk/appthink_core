import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';

typedef WidgetForStateFactory<M, S extends BaseState<M>> = Widget Function(
    BuildContext, S, EventsListener);

abstract class BaseWidget<M, S extends BaseState<M>> extends StatelessWidget
    implements EventsListener {
  late final EventsListener? Function() _eventListenerProvider;
  late final Bloc<WidgetEvents, S> _bloc;
  final WidgetForStateFactory<M, S> widgetForStateFactory;

  BaseWidget(this.widgetForStateFactory, {Key? key}) : super(key: key);

  @protected
  Bloc<WidgetEvents, S> createBloc(BuildContext context);

  @override
  Widget build(BuildContext context) {
    _eventListenerProvider = () => context.getOrNull<EventsListener>();
    _bloc = createBloc(context);
    _bloc..add(WidgetEvents.widgetCreated());
    return BlocBuilder<Bloc<WidgetEvents, S>, S>(
        bloc: _bloc,
        builder: (context, state) =>
            widgetForStateFactory.call(context, state, this));
  }

  @override
  void onNewEvent(AplEvent event) {
    if (event is WidgetEvents) {
      _bloc.add(event);
    } else {
      _eventListenerProvider.call()?.onNewEvent(event);
    }
  }
}
