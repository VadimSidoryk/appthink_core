import 'package:appthink_core/presentation/events.dart';
import 'package:flutter/widgets.dart';

import 'event_bus.dart';

class NavigatorEventsObserver extends NavigatorObserver {
  final EventBus _eventBus;

  NavigatorEventsObserver(this._eventBus);

  @override
  void didPop(Route currentRoute, Route? previousRoute) {
    _onTransition(to: previousRoute, from:  currentRoute);
  }

  @override
  void didPush(Route newRoute, Route? previousRoute) {
    _onTransition(to: newRoute, from: previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _onTransition(
        to: newRoute,
        from: oldRoute);
  }

  void _onTransition({required Route? to, required Route? from}) {
    final fromRouteName = from?.settings.name;
    final toRouteName = to?.settings.name ?? "undefined";
    _eventBus.onNewEvent(BaseWidgetEvents.screenTransition(fromRouteName, toRouteName));
  }
}