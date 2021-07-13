import 'package:applithium_core/services/analytics/trackable.dart';

import '../json/interpolation_args.dart';

const EVENT_ARG_NAME = "name";

const EVENT_SHOWN_NAME = "screen_shown";
const EVENT_SHOWN_ARG_ROUTE = "route";

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

class AplEvent extends Trackable implements InterpolationArgs {
  @override
  final String name;
  @override
  final Map<String, Object> params;

  AplEvent({required this.name, this.params = const {}});

  factory AplEvent.screenShown(String route) =>
      AplEvent(name: EVENT_SHOWN_NAME, params: {EVENT_SHOWN_ARG_ROUTE: route});

  factory AplEvent.dialogClosed(dynamic source, dynamic result) =>
      AplEvent(name: EVENT_DIALOG_CLOSED_NAME, params: {
        EVENT_DIALOG_CLOSED_ARG_SOURCE: source.toString(),
        EVENT_DIALOG_CLOSED_ARG_RESULT: result.toString()
      });

  factory AplEvent.updateRequested() =>
      AplEvent(name: EVENT_UPDATE_REQUESTED_NAME);

  factory AplEvent.displayData(dynamic data) => AplEvent(
      name: EVENT_DATA_UPDATED_NAME,
      params: {EVENT_DATA_UPDATED_ARG_DATA: data});

  factory AplEvent.displayListData(List<dynamic> data, bool isEndReached) =>
      AplEvent(name: EVENT_DATA_UPDATED_NAME, params: {
        EVENT_DATA_UPDATED_ARG_DATA: data,
        EVENT_DATA_UPDATED_ARG_IS_END_REACHED: isEndReached
      });

  factory AplEvent.scrollToEnd() => AplEvent(name: EVENT_SCROLLED_TO_END);

  factory AplEvent.sendForm() => AplEvent(name: EVENT_SEND_FORM_NAME);

  factory AplEvent.sessionStarted(
          {required int sessionCount,
          required int daysFromFirstSession,
          required int daysFromLastSession}) =>
      AplEvent(name: EVENT_SESSION_STARTED_NAME, params: {
        EVENT_SESSION_STARTED_ARG_SESSION_COUNT: sessionCount,
        EVENT_SESSION_STARTED_ARG_DAYS_FROM_FIRST_SESSION: daysFromFirstSession,
        EVENT_SESSION_STARTED_ARG_DAYS_FROM_LAST_SESSION: daysFromLastSession
      });

  factory AplEvent.screenOpened(String name) => AplEvent(
      name: EVENT_SCREEN_OPENED_NAME,
      params: {EVENT_SCREEN_OPENED_ARG_SCREEN_NAME: name});

  @override
  Map<String, dynamic> asArgs() {
    return params..[EVENT_ARG_NAME] = name;
  }
}
