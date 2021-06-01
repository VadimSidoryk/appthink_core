import 'dart:async';

import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/usage_listener.dart';

const sessionStartedEvent = "session_started";
const sessionCountProperty = "session_count";
const daysFromLastSessionProperty = "days_from_last_session";
const daysFromFirstSessionProperty = "days_from_first_session";
const secondsInAppProperty = "seconds_in_app";

class AnalyticsUsageAdapter extends UsageListener {

  final Analytics analytics;
  StreamSubscription? subscription;

  AnalyticsUsageAdapter(this.analytics);

  @override
  void onSessionStarted(int count, int daysFromFirstSession, int daysFromLastSession) {
    analytics.trackEventWithParams(sessionStartedEvent, {
      sessionCountProperty: count,
      daysFromFirstSessionProperty: daysFromFirstSession,
      daysFromLastSessionProperty: daysFromLastSession
    });
    analytics.setUserProperty(sessionCountProperty, count);
    subscription = analytics.periodicUpdatedUserProperty(secondsInAppProperty, Duration(seconds: 1));
  }

  @override
  void onSessionStopped() {
    subscription?.cancel();
    subscription = null;
  }
}