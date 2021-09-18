import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef WidgetForStateFactory<M, S extends BaseState<M>> = Widget Function(
    BuildContext, S, EventsListener);

abstract class BaseWidget<M, S extends BaseState<M>> extends StatelessWidget
    implements EventsListener {
  late final Bloc<WidgetEvents, S> _bloc;
  final WidgetForStateFactory<M, S> _widgetForStateFactory;

  BaseWidget(this._widgetForStateFactory, {Key? key}) : super(key: key);

  @protected
  Bloc<WidgetEvents, S> createBloc(BuildContext context);

  @override
  Widget build(BuildContext context) {
    _bloc = createBloc(context)..add(BaseWidgetEvents.widgetCreated(this));
    return BlocBuilder<Bloc<WidgetEvents, S>, S>(
        bloc: _bloc,
        builder: (context, state) => _widgetForStateFactory.call(context, state, this));
  }

  @override
  void onNewEvent(AppEvent event) {
    if (event is WidgetEvents) {
      _bloc.add(event);
    }
  }
}
