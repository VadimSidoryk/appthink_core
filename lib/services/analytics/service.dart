import 'dart:async';

import 'package:applithium_core/blocs/supervisor.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:applithium_core/services/analytics/config.dart';
import 'package:applithium_core/services/analytics/usage_adapter.dart';
import 'package:applithium_core/services/base.dart';
import 'package:applithium_core/services/history/usage_listener.dart';
import 'package:flutter/widgets.dart';

import 'analyst.dart';
import 'package:applithium_core/logs/extension.dart';

class AnalyticsService extends AplService<AnalyticsConfig> {
  final Set<Analyst> impls;

  AnalyticsService({required this.impls});

  List<NavigatorObserver> get navigatorObservers {
    return impls.map((impl) => impl.navigatorObserver).toList();
  }

  UsageListener asUsageListener() {
    return AnalyticsUsageAdapter(this);
  }

  BlocsListener asBlocListener() {
    return AnalyticsBlocAdapter(this);
  }

  void setUserProperty(String name, dynamic value) {
    log("setUserProperty $name : $value");
    impls.forEach((impl) => impl.setUserProperty(name, value));
  }

  void trackEvent({required String name, Map<String, Object>? params}) {
    log("trackEventWithParams $name params: $params");
    impls.forEach((impl) => impl.trackEvent(name: name, params: params));
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
}
