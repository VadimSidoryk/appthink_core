import 'dart:async';

import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:applithium_core/services/analytics/config.dart';
import 'package:applithium_core/services/analytics/usage_adapter.dart';
import 'package:applithium_core/services/base.dart';
import 'package:applithium_core/services/history/usage_listener.dart';
import 'package:flutter/widgets.dart';

import '../services/analytics/analyst.dart';
import 'package:applithium_core/logs/extension.dart';

class EventBus {
  final Set<EventsListener> impls;

  EventBus({required this.impls});

  List<NavigatorObserver> get navigatorObservers {
    return impls.map((impl) => impl.navigatorObserver).toList();
  }

  SessionListener asUsageListener() {
    return SessionEventsAdapter(this);
  }

  BlocsListener asBlocListener() {
    return BlocEventsAdapter(this);
  }

  void setUserProperty(String name, dynamic value) {
    log("setUserProperty $name : $value");
    impls.forEach((impl) => impl.setUserProperty(name, value));
  }

  void onNewEvent({required String name, Map<String, Object>? params}) {
    log("onNewEvent $name params: $params");
    impls.forEach((impl) => impl.onNewEvent(name: name, params: params));
  }

  StreamSubscription periodicUpdatedUserProperty<T>(
      String eventName, Duration duration, T Function(T?) provider) {
    T? currentValue;
    return Stream.periodic(duration, (count) {
      currentValue = provider.call(currentValue);
      return currentValue;
    }).listen((value) => setUserProperty(eventName, value));
  }
}
