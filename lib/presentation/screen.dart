import 'package:appthink_core/events/event_bus.dart';
import 'package:appthink_core/logs/extension.dart';
import 'package:appthink_core/scopes/extensions.dart';
import 'package:flutter/cupertino.dart';

import 'events.dart';
import 'lifecycle_listener.dart';

abstract class AplScreenState<W extends StatefulWidget> extends State<W> {
  late LifecycleListeners _listeners;

  @override
  void initState() {
    super.initState();
    _listeners = LifecycleListeners(
        onResume: () async =>
            onEventImpl(BaseWidgetEvents.screenResumed(this)),
        onPause: () async =>
            onEventImpl(BaseWidgetEvents.screenPaused(this)));
    WidgetsBinding.instance.addObserver(_listeners);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
  void deactivate() {
    onEventImpl(BaseWidgetEvents.screenDestroyed(this));
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(_listeners);
    super.dispose();
  }
}