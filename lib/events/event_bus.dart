import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/supervisor.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:flutter/widgets.dart';

import 'events_listener.dart';

class EventBus {
  final Set<EventsListener> listeners;

  EventBus({required this.listeners});

  List<NavigatorObserver> get navigatorObservers {
    return listeners
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }

  BlocsListener get blocListener {
    return BlocEventsAdapter(this);
  }

  void onNewEvent(AplEvent event) {
    log("onNewEvent ${event.name} params: ${event.params}");
    listeners.forEach((impl) => impl.onNewEvent(event));
  }
}
