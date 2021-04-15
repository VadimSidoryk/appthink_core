import 'package:flutter/widgets.dart';

abstract class Analyst {

  void trackRevenue(String productName, {double price, int quantity = 1});

  void trackEvent(String eventName);

  void trackEventWithParams(String eventName, Map<String, Object> params);

  void setUserProperty(String name, dynamic value);

  void addUserProperty(String name, num value);

  NavigatorObserver get navigatorObserver;

}