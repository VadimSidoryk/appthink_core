import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:flutter/widgets.dart';

class LogAnalyst extends Analyst {
  @override
  List<NavigatorObserver> get navigatorObservers => [];

  @override
  void setUserProperty(String name, value) {
    logMethod(methodName: "setUserProperty", params: [name, value]);
  }

  @override
  void onNewEvent(AplEvent event) {
    logMethod(methodName: "trackEventWithParams", params: [event.name, event.params]);
  }
}
