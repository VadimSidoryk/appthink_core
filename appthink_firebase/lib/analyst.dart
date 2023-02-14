import 'package:appthink_core/services/analytics/analyst.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';


class FirebaseAnalyst extends Analyst {

  final FirebaseAnalytics _analytics;

  FirebaseAnalyst(this._analytics);

  @override
  List<NavigatorObserver> get navigatorObservers => [ FirebaseAnalyticsObserver(analytics: _analytics) ];

  @override
  void setUserProperty(String name, Object? value) {
    _analytics.setUserProperty(name: name, value: value?.toString());
  }

  @override
  void sendEvent(String name, Map<String, Object?>? params) {
    _analytics.logEvent(name: name, parameters: params);
  }
}