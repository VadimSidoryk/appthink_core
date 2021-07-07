import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

class LogAnalyst extends EventsListener {
  @override
  NavigatorObserver get navigatorObserver => _LogsNavigatorObserver(this);

  @override
  void setUserProperty(String name, value) {
    logMethod(methodName: "setUserProperty", params: [name, value]);
  }

  @override
  void onNewEvent({required String name, Map<String, Object>? params}) {
    logMethod(methodName: "trackEventWithParams", params: [name, params]);
  }
}

class _LogsNavigatorObserver extends NavigatorObserver {
  final LogAnalyst impl;

  _LogsNavigatorObserver(this.impl);

  @override
  void didPop(Route newRoute, Route? previousRoute) async {
    if (previousRoute is PageRoute && newRoute is PageRoute) {
      final name = newRoute.settings.name;
      impl.onNewEvent(name: "${name}_opened");
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) async {
    if (route is PageRoute) {
      final name = route.settings.name;
      impl.onNewEvent(name: "${name}_opened");
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) async {
    if (newRoute is PageRoute) {
      final name = newRoute.settings.name;
      impl.onNewEvent(name: "${name}_opened");
    }
  }
}
