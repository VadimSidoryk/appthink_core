import 'dart:async';

import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'trackable.dart';
import 'package:applithium_core/logs/extension.dart';

class Analytics {

  final Set<Analyst> impls;

  Analytics({required this.impls});

  List<NavigatorObserver> get navigatorObservers {
    return impls.map((impl) => impl.navigatorObserver).toList();
  }

  BlocsListener get blocListener => AnalyticsBlocAdapter(this);

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

  void trackRevenue(String productName, {required double price, int quantity = 1}) {
    log("trackRevenue $productName price=$price qunantity=$quantity");
    impls.forEach((impl) =>
        impl.trackRevenue(productName, price: price, quantity: quantity));
  }

  void addUserProperty(String name, num value) {
    log("addUserProperty $name : $value");
    impls.forEach((impl) => impl.addUserProperty(name, value));
  }

  StreamSubscription periodicUpdatedUserProperty(String eventName,
      Duration duration) {
    return Stream.periodic(duration, (count) => count + 1)
        .listen((value) => setUserProperty(eventName, value));
  }
}
