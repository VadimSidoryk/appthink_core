import 'dart:async';

import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/usage_listener.dart';

const sessionStartedEvent = "session_started";
const sessionCountProperty = "session_count";
const daysFromLastSessionProperty = "days_from_last_session";
const daysFromFirstSessionProperty = "days_from_first_session";
const secondsInAppProperty = "seconds_in_app";

class SessionEventsAdapter extends SessionListener {
  final EventBus eventBus;
  final AnalyticsService analyticsService;
  StreamSubscription? subscription;

  SessionEventsAdapter(this.eventBus, this.analyticsService);

  @override
  void onSessionStarted(
      int count, int daysFromFirstSession, int daysFromLastSession) {
    eventBus.onNewEvent(name: sessionStartedEvent, params: {
      sessionCountProperty: count,
      daysFromFirstSessionProperty: daysFromFirstSession,
      daysFromLastSessionProperty: daysFromLastSession
    });
    analyticsService.setUserProperty(sessionCountProperty, count);
    subscription = analyticsService.periodicUpdatedUserProperty<int>(
        secondsInAppProperty, Duration(seconds: 10), (sec) => (sec ?? 0) + 10);
  }

  @override
  void onSessionPaused() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void onSessionResumed() {
    subscription = analyticsService.periodicUpdatedUserProperty<int>(
        secondsInAppProperty, Duration(seconds: 10), (sec) => (sec ?? 0) + 10);
  }
}
