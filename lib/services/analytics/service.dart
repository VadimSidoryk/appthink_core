import 'dart:async';

import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/base.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'config.dart';

class AnalyticsService extends AplService<AnalyticsConfig>
    implements EventsListener {
  final List<Analyst> analysts = [];

  void addAnalyst(Analyst analyst) {
    logMethod(methodName: "addAnalyst", params: [analyst]);
    analysts.add(analyst);
  }

  void setUserProperty(String name, dynamic value) {
    logMethod(methodName: "setUserProperty", params: [name, value]);
    analysts.forEach((impl) => impl.setUserProperty(name, value));
  }

  @override
  void onNewEvent(AplEvent event) {
    logMethod(methodName: "trackEventWithParams", params: [event]);
    analysts.forEach((impl) => impl.onNewEvent(event));
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
  void init(BuildContext context, AnalyticsConfig config) {
    // TODO: implement init
  }

  @override
  List<NavigatorObserver> get navigatorObservers {
    logMethod(methodName: "navigatorObservers");
    return analysts
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }
}
