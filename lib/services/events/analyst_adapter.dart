import 'package:applithium_core/events/events_listener.dart';
import 'package:flutter/cupertino.dart';

import 'service.dart';

class EventsHandlerAdapter extends EventsListener {
  final EventHandlerService _service;

  EventsHandlerAdapter(this._service);

  @override
  List<NavigatorObserver> get navigatorObservers =>
      [ _NavigatorEventsObserver(_service) ];

  @override
  void onNewEvent({required String name, Map<String, Object>? params}) async {
    _service.handleEvent(name: name, params: params);
  }
}

class _NavigatorEventsObserver extends NavigatorObserver {
  static String _getScreenEvent(String screenName) => "${screenName}_opened";

  final EventHandlerService _service;

  _NavigatorEventsObserver(this._service);

  @override
  void didPop(Route newRoute, Route? previousRoute) {
    if (previousRoute is PageRoute && newRoute is PageRoute) {
      _service.handleEvent(
          name: _getScreenEvent(previousRoute.settings.name ?? "undefined"));
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      _service.handleEvent(name: _getScreenEvent(route.settings.name ?? "undefined"));
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
      _service.handleEvent(name: _getScreenEvent(newRoute.settings.name ?? "undefined"));
    }
  }
}
