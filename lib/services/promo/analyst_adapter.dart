import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:flutter/cupertino.dart';

import 'service.dart';

class PromoEventsAdapter extends SystemListener {
  final PromoService _service;

  PromoEventsAdapter(this._service);

  @override
  List<NavigatorObserver> get navigatorObservers =>
      [_NavigatorEventsObserver(_service)];

  @override
  void onNewEvent(AplEvent event) async {
    _service.handleEvent(event);
  }
}

class _NavigatorEventsObserver extends NavigatorObserver {
  final PromoService _service;

  _NavigatorEventsObserver(this._service);

  @override
  void didPop(Route newRoute, Route? previousRoute) {
    if (previousRoute is PageRoute && newRoute is PageRoute) {
      final name = newRoute.settings.name ?? "undefined";
      _service.handleEvent(BaseWidgetEvents.widgetShown(name));
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      final name = route.settings.name ?? "undefined";
      _service.handleEvent(BaseWidgetEvents.widgetShown(name));
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
      final name = newRoute.settings.name ?? "undefined";
      _service.handleEvent(BaseWidgetEvents.widgetShown(name));
    }
  }
}
