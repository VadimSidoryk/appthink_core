import 'package:applithium_core/events/trackable.dart';


const EVENT_ARG_NAME = "name";

const EVENT_CREATED_NAME = "screen_created";

const EVENT_DIALOG_CLOSED_NAME = "dialog_closed";
const EVENT_DIALOG_CLOSED_ARG_SOURCE = "source";
const EVENT_DIALOG_CLOSED_ARG_RESULT = "result";

const EVENT_UPDATE_REQUESTED_NAME = "update_requested";

const EVENT_DATA_UPDATED_NAME = "data_updated";
const EVENT_DATA_UPDATED_ARG_DATA = "data";
const EVENT_DATA_UPDATED_ARG_IS_END_REACHED = "is_end_reached";

const EVENT_SCROLLED_TO_END = "scrolled_to_end";

const EVENT_SEND_FORM_NAME = "send_form";

const EVENT_SESSION_STARTED_NAME = "session_started";
const EVENT_SESSION_STARTED_ARG_SESSION_COUNT = "session_count";
const EVENT_SESSION_STARTED_ARG_DAYS_FROM_LAST_SESSION =
    "days_from_last_session";
const EVENT_SESSION_STARTED_ARG_DAYS_FROM_FIRST_SESSION =
    "days_from_first_session";

const EVENT_SCREEN_OPENED_NAME = "screen_opened";
const EVENT_SCREEN_OPENED_ARG_SCREEN_NAME = "screen_name";

abstract class AppEvent extends Trackable  {
  @override
  final String name;

  @override
  final Map<String, Object> params;

  AppEvent(this.name, [Map<String, Object>? params]): params = params ?? {};

  factory AppEvent.sessionStarted(int sessionCount,  int daysFromFirstSession, int dayFromLastSession) =>
  SessionStarted._(sessionCount, daysFromFirstSession, dayFromLastSession);

  Map<String, dynamic> asArgs() {
    return params..[EVENT_ARG_NAME] = name;
  }
}

class SessionStarted extends AppEvent {

  final int sessionCount;
  final int daysFromLastSession;
  final int daysFromFirstSession;

  SessionStarted._(this.sessionCount, this.daysFromFirstSession,
      this.daysFromLastSession) : super(EVENT_SESSION_STARTED_NAME);

  @override
  Map<String, Object> get params => {
    EVENT_SESSION_STARTED_ARG_SESSION_COUNT : sessionCount,
    EVENT_SESSION_STARTED_ARG_DAYS_FROM_FIRST_SESSION : daysFromFirstSession,
    EVENT_SESSION_STARTED_ARG_DAYS_FROM_LAST_SESSION : daysFromLastSession
  };
}
