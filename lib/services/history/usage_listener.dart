abstract class SessionListener {
  void onSessionStarted(int count, int daysFromFirstSession, int daysFromLastSession);

  void onSessionPaused();

  void onSessionResumed();

}