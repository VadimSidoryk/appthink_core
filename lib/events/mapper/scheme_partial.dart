import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/utils/extension.dart';

import '../base_event.dart';
import 'scheme.dart';

abstract class PartialEventsScheme extends EventsScheme {

  Set<EventsHandler> get parts;

  @override
  List<EventData>? mapEventImpl(AplEvent event) {
    List<EventData>? eventsToSend;
    parts.where((it) => it.shouldHandleEvent(event)).forEach((it) {
      try {
        final eventsDataFromMapper = it.mapEvent(event);
        if (eventsToSend == null) {
          eventsToSend = <EventData>[];
        }
        eventsDataFromMapper.let((it) {
          eventsToSend!.addAll(it);
        });
      } catch (e, stacktrace) {
        logError("mapEventImpl", e, stacktrace);
      }
    });
    return eventsToSend;
  }
}

abstract class EventsHandler {
  bool shouldHandleEvent(AplEvent event);

  List<EventData> mapEvent(AplEvent event);
}