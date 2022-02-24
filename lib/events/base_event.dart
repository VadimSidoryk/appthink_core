abstract class AplEvent {
  AplEvent();

  factory AplEvent.sessionStarted(
          int sessionCount, int daysFromFirstSession, int dayFromLastSession) =>
      SessionStarted._(sessionCount, daysFromFirstSession, dayFromLastSession);
}

class SessionStarted extends AplEvent {
  final int sessionCount;
  final int daysFromLastSession;
  final int daysFromFirstSession;

  SessionStarted._(
      this.sessionCount, this.daysFromFirstSession, this.daysFromLastSession);
}
