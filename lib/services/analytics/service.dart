import 'dart:async';

import 'package:appthink_core/events/mapper/scheme.dart';
import 'package:appthink_core/events/system_listener.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';

class AnalyticsService implements SystemListener {
  final List<Analyst> analysts = [];

  void addAnalyst(Analyst analyst) {
    analysts.add(analyst);
  }

  void setUserProperty(String name, dynamic value) {
    analysts.forEach((impl) => impl.setUserProperty(name, value));
  }

  @override
  void onEvent(EventData eventData) {
    analysts.forEach((impl) => impl.onEvent(eventData));
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
    return analysts
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }
}