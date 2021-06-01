import 'dart:async';

import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:applithium_core/services/analytics/usage_adapter.dart';
import 'package:applithium_core/services/history/usage_listener.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'package:applithium_core/logs/extension.dart';

class Analytics {
  final Set<Analyst> impls;

  Analytics({required this.impls});

  List<NavigatorObserver> get navigatorObservers {
    return impls.map((impl) => impl.navigatorObserver).toList();
  }

  UsageListener asUsageListener() {
    return AnalyticsUsageAdapter(this);
  }

  BlocsListener asBlocListener() {
    return AnalyticsBlocAdapter(this);
  }

  void setUserProperty(String name, dynamic value) {
    log("setUserProperty $name : $value");
    impls.forEach((impl) => impl.setUserProperty(name, value));
  }

  void trackEvent(String eventName) {
    log("trackEvent $eventName");
    impls.forEach((impl) => impl.trackEvent(eventName));
  }

  void trackEventWithParams(String eventName, Map<String, Object> params) {
    log("trackEventWithParams $eventName params: $params");
    impls.forEach((impl) => impl.trackEventWithParams(eventName, params));
  }

  void trackRevenue(String productName,
      {required double price, int quantity = 1}) {
    log("trackRevenue $productName price=$price qunantity=$quantity");
    impls.forEach((impl) =>
        impl.trackRevenue(productName, price: price, quantity: quantity));
  }

  void addUserProperty(String name, num value) {
    log("addUserProperty $name : $value");
    impls.forEach((impl) => impl.addUserProperty(name, value));
  }

  StreamSubscription periodicUpdatedUserProperty<T>(
      String eventName, Duration duration, T Function(T?) provider) {
    T? currentValue;
    return Stream.periodic(duration, (count) {
      currentValue = provider.call(currentValue);
      return currentValue;
    }).listen((value) => setUserProperty(eventName, value));
  }
}
