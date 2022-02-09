import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/logs/extension.dart';


class FirebaseAnalystImpl extends Analyst {

  final FirebaseAnalytics _analytics;

  FirebaseAnalystImpl(this._analytics);

  @override
  List<NavigatorObserver> get navigatorObservers => [ FirebaseAnalyticsObserver(analytics: _analytics) ];

  @override
  void setUserProperty(String name, Object? value) {
    logMethod("setUserProperty", params: [name , value]);
    _analytics.setUserProperty(name: name, value: value?.toString());
  }

  @override
  void onEvent(AplEvent event) {
    logMethod("onNewEvent", params: [event]);
    _analytics.logEvent(name: event.name, parameters: event.params);
  }
}