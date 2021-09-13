import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:flutter/widgets.dart';

class LogAnalyst extends Analyst {
  @override
  List<NavigatorObserver> get navigatorObservers => [];

  @override
  void setUserProperty(String name, value) {
    logMethod("setUserProperty", params: [name, value]);
  }

  @override
  void onNewEvent(AppEvent event) {
    logMethod("trackEventWithParams", params: [event.name, event.params]);
  }
}
