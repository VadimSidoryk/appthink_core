import 'package:applithium_core/events/events_listener.dart';
import 'package:flutter/widgets.dart';

abstract class Analyst extends EventsListener {

  void setUserProperty(String name, Object? value);

  List<NavigatorObserver> get navigatorObservers;
}