import 'package:applithium_core/events/event.dart';
import 'package:flutter/widgets.dart';

abstract class EventsListener {

  void onNewEvent(AplEvent event);

  List<NavigatorObserver> get navigatorObservers;

}