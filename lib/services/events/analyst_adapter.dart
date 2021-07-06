import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:flutter/cupertino.dart';

import 'service.dart';

class PromoEventsAnalyticsAdapter extends Analyst {
  static String _getRevenueEvent(String productName) =>
      "${productName}_purchased";

  final Future<AppEventsService> _initializedService;

  PromoEventsAnalyticsAdapter(this._initializedService);

  @override
  NavigatorObserver get navigatorObserver =>
      _NavigatorEventsObserver(_initializedService);

  @override
  void setUserProperty(String name, value) {}

  @override
  void trackEvent({required String name, Map<String, Object>? params}) async {
    final service = await _initializedService;
    service.checkEvent(name: name, params: params);
  }
}

class _NavigatorEventsObserver extends NavigatorObserver {
  static String _getScreenEvent(String screenName) => "${screenName}_opened";

  final Future<AppEventsService> _initializedService;

  _NavigatorEventsObserver(this._initializedService);

  @override
  void didPop(Route newRoute, Route? previousRoute) async {
    if (previousRoute is PageRoute && newRoute is PageRoute) {
      final service = await _initializedService;
      service.checkEvent(
          name: _getScreenEvent(previousRoute.settings.name ?? "undefined"));
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) async {
    if (route is PageRoute) {
      final service = await _initializedService;
      service.checkEvent(name: _getScreenEvent(route.settings.name ?? "undefined"));
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) async {
    if (newRoute is PageRoute) {
      final service = await _initializedService;
      service
          .checkEvent(name: _getScreenEvent(newRoute.settings.name ?? "undefined"));
    }
  }
}
