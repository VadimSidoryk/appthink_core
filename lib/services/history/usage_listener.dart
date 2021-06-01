abstract class UsageListener {
  void onSessionStarted(int count, int daysFromFirstSession, int daysFromLastSession);

  void onSessionStopped();
}