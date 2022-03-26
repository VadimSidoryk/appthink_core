import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter/cupertino.dart';

import 'events.dart';

abstract class AplScreenState<W extends StatefulWidget, E extends WidgetEvents> extends State<W> implements EventsListener<E> {

  @override
  void initState() {
    super.initState();
    onEventImpl(BaseWidgetEvents.screenCreated(this));
  }

  @override
  void onEvent(E event) {
    onEventImpl(event);
  }

  @protected
  void onEventImpl(WidgetEvents event) {
    try {
      final eventBus = context.getOrNull<EventBus>();
      eventBus?.onNewEvent(event);
    } catch (e, stacktrace) {
      widget.logError("process in eventBus", e, stacktrace);
    }
  }

  @override
  void dispose() {
    onEventImpl(BaseWidgetEvents.screenDestroyed(this));
    super.dispose();
  }
}