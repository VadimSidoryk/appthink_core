import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';

class LogAnalyst extends Analyst {
  @override
  List<NavigatorObserver> get navigatorObservers => [];

  LogAnalyst();

  @override
  void setUserProperty(String name, value) {
    log("setUserProperty [name: $name, value: $value]");
  }

  @override
  void sendEvent(String event, Map<String, Object?>? params) {
    log("sendEvent [name:$event, params: $params]");
  }
}
