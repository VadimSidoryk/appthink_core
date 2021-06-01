import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

class LogAnalyst extends Analyst {
  @override
  void addUserProperty(String name, num value) {
    logMethod(methodName: "addUserProperty", params: [name, value]);
  }

  @override
  NavigatorObserver get navigatorObserver => _LogsNavigatorObserver(this);

  @override
  void setUserProperty(String name, value) {
    logMethod(methodName: "setUserProperty", params: [name, value]);

  }

  @override
  void trackEvent(String eventName) {
    logMethod(methodName: "trackEvent");
  }

  @override
  void trackEventWithParams(String eventName, Map<String, Object> params) {
    logMethod(methodName: "trackEventWithParams", params: [eventName, params]);
  }

  @override
  void trackRevenue(String productName, {required double price, int
  quantity = 1}) {
    logMethod(methodName: "trackRevenue", params: [productName, price, quantity]);

  }
}

class _LogsNavigatorObserver extends NavigatorObserver {

  final LogAnalyst impl;

  _LogsNavigatorObserver(this.impl);

  @override
  void didPop(Route newRoute, Route? previousRoute) async {
    if(previousRoute is PageRoute && newRoute is PageRoute) {
      final name = newRoute.settings.name;
      impl.trackEvent("${name}_opened");
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) async {
    if (route is PageRoute) {
      final name = route.settings.name;
      impl.trackEvent("${name}_opened");
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) async {
    if(newRoute is PageRoute) {
      final name = newRoute.settings.name;
      impl.trackEvent("${name}_opened");
    }
  }
}