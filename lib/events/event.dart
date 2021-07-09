import 'package:applithium_core/services/analytics/trackable.dart';

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

class AplEvent extends Trackable {
  @override
  final String name;
  @override
  final Map<String, Object> params;

  AplEvent({required this.name, required this.params});

  factory AplEvent.screenShown(String route) =>
      AplEvent(name: EVENT_SHOWN_NAME, params: {EVENT_SHOWN_ARG_ROUTE: route});

  factory AplEvent.dialogClosed(dynamic source, dynamic result) =>
      AplEvent(name: EVENT_DIALOG_CLOSED_NAME, params: {
        EVENT_DIALOG_CLOSED_ARG_SOURCE: source.toString(),
        EVENT_DIALOG_CLOSED_ARG_RESULT: result.toString()
      });

  factory AplEvent.updateRequested() => AplEvent(
    name: EVENT_UPDATE_REQUESTED_NAME,
    params: {}
  );

  factory AplEvent.displayData(dynamic data) =>
      AplEvent(name: EVENT_DATA_UPDATED_NAME, params: {
        EVENT_DATA_UPDATED_ARG_DATA : data
      });

  factory AplEvent.displayListData(List<dynamic> data, bool isEndReached) =>
      AplEvent(name: EVENT_DATA_UPDATED_NAME, params: {
        EVENT_DATA_UPDATED_ARG_DATA : data,
        EVENT_DATA_UPDATED_ARG_IS_END_REACHED: isEndReached
      });

  factory AplEvent.scrollToEnd() => AplEvent(
    name: EVENT_SCROLLED_TO_END,
    params: {}
  );
}
