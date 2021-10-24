import 'dart:async';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/service_base.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';

import 'analyst.dart';

class AnalyticsService extends AplService implements SystemListener {
  final List<Analyst> analysts = const [];

  AnalyticsService();

  @override
  Future<void> init(AplConfig appConfig) async {
    //TODO: add config here
  }

  void addAnalyst(Analyst analyst) {
    logMethod("addAnalyst", params: [analyst]);
    analysts.add(analyst);
  }

  void setUserProperty(String name, dynamic value) {
    logMethod("setUserProperty", params: [name, value]);
    analysts.forEach((impl) => impl.setUserProperty(name, value));
  }

  @override
  void onNewEvent(AplEvent event) {
    logMethod("trackEventWithParams", params: [event]);
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
  List<NavigatorObserver> get navigatorObservers {
    logMethod("navigatorObservers");
    return analysts
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }

  @override
  void addToStore(Store store) {
    store.add((provider) {
      this..addAnalyst(LogAnalyst());
      provider.get<EventBus>().addListener(this);
      return this;
    });
  }
}
