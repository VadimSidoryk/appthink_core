import 'package:applithium_core/events/mapper/scheme.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

import 'base_event.dart';
import 'system_listener.dart';

class EventBus {
  final EventsScheme scheme;
  final Set<SystemListener> listeners;

  EventBus({required this.scheme, required this.listeners});

  List<NavigatorObserver> get navigatorObservers {
    return listeners
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }

  void onNewEvent(AplEvent event) {
    final events = scheme.mapEvent(event);
    events?.forEach((event) {
      listeners.forEach((impl) {
        impl.onEvent(event);
      });
    });
  }
}
