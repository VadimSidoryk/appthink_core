import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

class EventBus {
  final Set<SystemListener> listeners;

  EventBus({required this.listeners});

  List<NavigatorObserver> get navigatorObservers {
    return listeners
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }

  void onNewEvent(AplEvent event) {
    log("onNewEvent ${event.name} params: ${event.params}");
    listeners.forEach((impl) => impl.onNewEvent(event));
  }
}
