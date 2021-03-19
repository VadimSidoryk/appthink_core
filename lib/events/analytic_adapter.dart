import 'package:applithium_core/analytics/analyst.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/navigator.dart';

import 'service.dart';


class AnalyticEventsAdapter extends Analyst {

  static String _getRevenueEvent(String productName) => "${productName}_purchased";

  final Future<AppEventsService> _initializedService;

  AnalyticEventsAdapter(this._initializedService);

  @override
  void addUserProperty(String name, num value) { }

  @override
  NavigatorObserver get navigatorObserver => _NavigatorEventsObserver(_initializedService);

  @override
  void setUserProperty(String name, value) { }

  @override
  void trackEvent(String eventName) async {
    final service = await _initializedService;
    service.checkEvent(eventName);
  }

  @override
  void trackEventWithParams(String eventName, Map<String, Object> params) async {
    final service = await _initializedService;
    service.checkEvent(eventName);
  }

  @override
  void trackRevenue(String productName, {double price, int quantity = 1}) async {
    final service = await _initializedService;
    service.checkEvent(_getRevenueEvent(productName));
  }
}

class _NavigatorEventsObserver extends NavigatorObserver {

  static String _getScreenEvent(String screenName) => "${screenName}_opened";

  final Future<AppEventsService> _initializedService;

  _NavigatorEventsObserver(this._initializedService);

  @override
  void didPop(Route newRoute, Route previousRoute) async {
    if(previousRoute is PageRoute && newRoute is PageRoute) {
      final service = await _initializedService;
      service.checkEvent(_getScreenEvent(previousRoute.settings.name));
    }

  }

  @override
  void didPush(Route route, Route previousRoute) async {
    if (route is PageRoute) {
      final service = await _initializedService;
      service.checkEvent(_getScreenEvent(route.settings.name));
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) async {
    if(newRoute is PageRoute) {
      final service = await _initializedService;
      service.checkEvent(_getScreenEvent(newRoute.settings.name));
    }
  }
}