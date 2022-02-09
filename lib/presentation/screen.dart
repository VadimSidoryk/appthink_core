import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/states.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core/utils/extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AplScreenState<W extends StatefulWidget, E extends WidgetEvents, S extends BaseState>
    extends State<W> implements EventsListener<E> {

  final String? screenName;
  final BlocBuilderCondition<S>? buildWhen;

  AplBloc<S>? _bloc;

  AplScreenState(this.screenName, this.buildWhen);

  AplBloc<S> createBloc(BuildContext context);

  Widget createWidget(
      BuildContext context, Stream<S> stream, EventsListener<E> listener);

  @override
  void initState() {
    super.initState();
    _bloc = createBloc(context);
    screenName?.let((it) {
      onEventImpl(BaseWidgetEvents.widgetCreated(it, widget.runtimeType));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        buildWhen: buildWhen,
        builder: (context, state) => createWidget(
            context, _bloc!.stream.asBroadcastStream(), this));
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  void onEvent(E event) {
    onEventImpl(event);
  }

  void onEventImpl(WidgetEvents event) {
    try {
      context.getOrNull<EventBus>()?.onNewEvent(event);
    } catch (e, stacktrace) {
      widget.logError("process in eventBus", e, stacktrace);
    }

    _bloc?.add(event);
  }
}
