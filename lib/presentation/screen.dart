import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter/cupertino.dart';

import 'events.dart';

abstract class AplScreenState<W extends StatefulWidget> extends State<W>  {

  @override
  void initState() {
    super.initState();
    onEventImpl(BaseWidgetEvents.screenCreated(this));
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