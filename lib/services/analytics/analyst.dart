import 'package:flutter/widgets.dart';

abstract class EventsListener {

  void onNewEvent({required String name, Map<String, Object>? params});

  void setUserProperty(String name, Object? value);

  NavigatorObserver get navigatorObserver;

}