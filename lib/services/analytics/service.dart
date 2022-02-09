import 'dart:async';

import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/logs/extension.dart';

import 'analyst.dart';

class AnalyticsService implements SystemListener {
  final List<Analyst> analysts = [];

  void addAnalyst(Analyst analyst) {
    logMethod("addAnalyst", params: [analyst]);
    analysts.add(analyst);
  }

  void setUserProperty(String name, dynamic value) {
    logMethod("setUserProperty", params: [name, value]);
    analysts.forEach((impl) => impl.setUserProperty(name, value));
  }

  @override
  void onEvent(AplEvent event) {
    logMethod("trackEventWithParams", params: [event]);
    analysts.forEach((impl) => impl.onEvent(event));
  }

  StreamSubscription periodicUpdatedUserProperty<T>(
      String eventName, Duration duration, T Function(T?) provider) {
    T? currentValue;
    return Stream.periodic(duration, (count) {
      currentValue = provider.call(currentValue);
      return currentValue;
    }).listen((value) => setUserProperty(eventName, value));
  }

  @override
  List<NavigatorObserver> get navigatorObservers {
    logMethod("navigatorObservers");
    return analysts
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }
}