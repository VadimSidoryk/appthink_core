import 'dart:async';

import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/services/history/usage_listener.dart';

import 'service.dart';

const secondsInAppProperty = "seconds_in_app";

class AnalyticsSessionAdapter extends SessionListener {
  final EventBus eventBus;
  final AnalyticsService analyticsService;
  StreamSubscription? subscription;

  AnalyticsSessionAdapter(this.eventBus, this.analyticsService);

  @override
  void onSessionStarted(int count, int daysFromFirstSession,
      int daysFromLastSession) {
    eventBus.onNewEvent(AplEvent.sessionStarted(count, daysFromFirstSession, daysFromLastSession));
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
