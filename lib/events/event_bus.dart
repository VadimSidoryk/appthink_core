import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/logs/extension.dart';
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

  void onNewEvent({required String name, Map<String, Object>? params}) {
    log("onNewEvent $name params: $params");
    listeners.forEach((impl) => impl.onNewEvent(name: name, params: params));
  }
}
