import 'package:flutter/widgets.dart';

abstract class EventsListener {

  void onNewEvent({required String name, Map<String, Object>? params});

  List<NavigatorObserver> get navigatorObservers;

}