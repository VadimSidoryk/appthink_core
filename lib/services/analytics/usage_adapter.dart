import 'dart:async';

import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/history/usage_listener.dart';


const secondsInAppProperty = "seconds_in_app";

class SessionEventsAdapter extends SessionListener {
  final EventBus eventBus;
  final AnalyticsService analyticsService;
  StreamSubscription? subscription;

  SessionEventsAdapter(this.eventBus, this.analyticsService);

  @override
  void onSessionStarted(int count, int daysFromFirstSession,
      int daysFromLastSession) {
    eventBus.onNewEvent(AplEvent.sessionStarted(count, daysFromFirstSession, daysFromLastSession));
    analyticsService.setUserProperty(EVENT_SESSION_STARTED_ARG_SESSION_COUNT, count);
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
