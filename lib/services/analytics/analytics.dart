import 'dart:async';

import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'trackable.dart';
import 'package:applithium_core/logs/extension.dart';

class Analytics {

  final Set<Analyst> _impls;

  Analytics(this._impls);

  List<NavigatorObserver> get navigatorObservers {
    return _impls.map((impl) => impl.navigatorObserver).toList();
  }

  void setUserProperty(String name, dynamic value) {
    log("setUserProperty $name : $value");
    _impls.forEach((impl) => impl.setUserProperty(name, value));
  }

  void trackEvent(String eventName) {
    log("trackEvent $eventName");
    _impls.forEach((impl) => impl.trackEvent(eventName));
  }

  void trackEventWithParams(String eventName, Map<String, Object> params) {
    log("trackEventWithParams $eventName params: $params");
    _impls.forEach((impl) => impl.trackEventWithParams(eventName, params));
  }

  void trackRevenue(String productName, {required double price, int quantity = 1}) {
    log("trackRevenue $productName price=$price qunantity=$quantity");
    _impls.forEach((impl) =>
        impl.trackRevenue(productName, price: price, quantity: quantity));
  }

  void addUserProperty(String name, num value) {
    log("addUserProperty $name : $value");
    _impls.forEach((impl) => impl.addUserProperty(name, value));
  }

  StreamSubscription periodicUpdatedUserProperty(String eventName,
      Duration duration) {
    return Stream.periodic(duration, (count) => count + 1)
        .listen((value) => addUserProperty(eventName, value));
  }

  Function(Trackable) asLoggableObs() =>
          (Trackable state) {
        trackEventWithParams(state.analyticTag, state.analyticParams);
      };
}
