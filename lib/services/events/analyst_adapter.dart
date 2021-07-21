import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:flutter/cupertino.dart';

import 'service.dart';

class TriggeredEventsHandlerAdapter extends EventsListener {
  final EventTriggeredHandlerService _service;

  TriggeredEventsHandlerAdapter(this._service);

  @override
  List<NavigatorObserver> get navigatorObservers =>
      [_NavigatorEventsObserver(_service)];

  @override
  void onNewEvent(AplEvent event) async {
    _service.handleEvent(event);
  }
}

class _NavigatorEventsObserver extends NavigatorObserver {
  final EventTriggeredHandlerService _service;

  _NavigatorEventsObserver(this._service);

  @override
  void didPop(Route newRoute, Route? previousRoute) {
    if (previousRoute is PageRoute && newRoute is PageRoute) {
      final name = newRoute.settings.name ?? "undefined";
      _service.handleEvent(AplEvent.screenOpened(name));
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      final name = route.settings.name ?? "undefined";
      _service.handleEvent(AplEvent.screenOpened(name));
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
      final name = newRoute.settings.name ?? "undefined";
      _service.handleEvent(AplEvent.screenOpened(name));
    }
  }
}
