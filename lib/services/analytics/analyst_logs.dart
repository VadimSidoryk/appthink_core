import 'package:applithium_core/events/base_event.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/logs/extension.dart';

import 'analyst.dart';

class LogAnalyst extends Analyst {
  @override
  List<NavigatorObserver> get navigatorObservers => [];

  @override
  void setUserProperty(String name, value) {
    logMethod("setUserProperty", params: [name, value]);
  }

  @override
  void onEvent(AplEvent event) {
    logMethod("trackEventWithParams", params: [event.name, event.params]);
  }
}