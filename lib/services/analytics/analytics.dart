import 'dart:async';

import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'trackable.dart';

class Analytics {

  final Set<Analyst> _impls;

  Analytics(this._impls);

  List<NavigatorObserver> get navigatorObservers {
    return _impls.map((impl) => impl.navigatorObserver).toList();
  }

  void setUserProperty(String name, dynamic value) {
    print("setUserProperty $name : $value");
    _impls.forEach((impl) => impl.setUserProperty(name, value));
  }

  void trackEvent(String eventName) {
    print("trackEvent $eventName");
    _impls.forEach((impl) => impl.trackEvent(eventName));
  }

  void trackEventWithParams(String eventName, Map<String, Object> params) {
    print("trackEventWithParams $eventName params: $params");
    _impls.forEach((impl) => impl.trackEventWithParams(eventName, params));
  }

  void trackRevenue(String productName, {required double price, int quantity = 1}) {
    print("trackRevenue $productName price=$price qunantity=$quantity");
    _impls.forEach((impl) =>
        impl.trackRevenue(productName, price: price, quantity: quantity));
  }

  void addUserProperty(String name, num value) {
    print("addUserProperty $name : $value");
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
