import 'dart:async';
import 'dart:developer';

import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/services/base.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'config.dart';

class AnalyticsService extends AplService<AnalyticsConfig>
    implements EventsListener {
  final Set<Analyst> analysts;

  AnalyticsService({required this.analysts});

  void setUserProperty(String name, dynamic value) {
    log("setUserProperty $name : $value");
    analysts.forEach((impl) => impl.setUserProperty(name, value));
  }

  @override
  void onNewEvent({required String name, Map<String, Object>? params}) {
    log("trackEventWithParams $name params: $params");
    analysts.forEach((impl) => impl.onNewEvent(name: name, params: params));
  }

  StreamSubscription periodicUpdatedUserProperty<T>(
      String eventName, Duration duration, T Function(T?) provider) {
    T? currentValue;
    return Stream.periodic(duration, (count) {
      currentValue = provider.call(currentValue);
      return currentValue;
    }).listen((value) => setUserProperty(eventName, value));
  }

  @override
  void init(BuildContext context, AnalyticsConfig config) {
    // TODO: implement init
  }

  @override
  List<NavigatorObserver> get navigatorObservers {
    return analysts
        .map((impl) => impl.navigatorObservers)
        .reduce((result, currentList) => result + currentList)
        .toList();
  }
}
