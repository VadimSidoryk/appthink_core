import 'dart:async';

import 'package:appthink_core/events/base_event.dart';
import 'package:appthink_core/events/event_bus.dart';
import 'package:appthink_core/services/history/usage_listener.dart';

import 'service.dart';

const secondsInAppProperty = "seconds_in_app";
const sessionCountProperty = "sessions_count";

class AnalyticsSessionAdapter extends HistoryListener {
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
    onPropertyIncremented(sessionCountProperty, count);
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

  @override
  void onPropertyIncremented(String name, int value) {
    analyticsService.setUserProperty(name, value);
  }
}
