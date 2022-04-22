abstract class HistoryListener {
  void onSessionStarted(int count, int daysFromFirstSession, int daysFromLastSession);

  void onSessionPaused();

  void onSessionResumed();

  void onPropertyIncremented(String name, int value);
}