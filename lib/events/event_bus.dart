import 'package:applithium_core/domain/supervisor.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:flutter/widgets.dart';

import 'events_listener.dart';

class EventBus {
  final Set<SystemListener> listeners;

  EventBus({required this.listeners});

  List<NavigatorObserver> get navigatorObservers {
    return listeners
        .map((impl) => impl.navigatorObserver)
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
