import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:applithium_core/logs/extension.dart';

class FirebaseAnalyst extends Analyst {

  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  List<NavigatorObserver> get navigatorObservers => [ FirebaseAnalyticsObserver(analytics: _analytics) ];

  @override
  void setUserProperty(String name, Object? value) {
    logMethod("setUserProperty", params: [name , value]);
    _analytics.setUserProperty(name: name, value: value?.toString());
  }

  @override
  void onNewEvent(AplEvent event) {
    logMethod("onNewEvent", params: [event]);
    _analytics.logEvent(name: event.name, parameters: event.params);
  }
}