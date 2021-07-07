import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/src/widgets/navigator.dart';

class FirebaseAnalyst extends EventsListener {

  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  NavigatorObserver get navigatorObserver => FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  void setUserProperty(String name, Object? value) {
    _analytics.setUserProperty(name: name, value: value?.toString());
  }

  @override
  void onNewEvent({required String name, Map<String, Object>? params}) {
    _analytics.logEvent(name: name, parameters: params);
  }
}