import 'package:appthink_core/events/base_event.dart';
import 'package:appthink_core/events/mapper/scheme.dart';

class FreezedEventsScheme extends EventsScheme {
  @override
  List<EventData>? mapEventImpl(AplEvent event) {
    String eventString = event.toString();
    final pointPosition = eventString.indexOf(".");
    if (pointPosition > 0) {
      eventString =
          eventString.substring(pointPosition + 1, eventString.length);
    }
    eventString =
        eventString.replaceAll("Instance of ", "").replaceAll("'", "");

    final eventParts = eventString
        .split(new RegExp(r'[,():]'))
        .where((it) => it != "")
        .toList();

    String name = eventParts.isNotEmpty ? eventParts[0] : "";
    name = name
        .replaceAllMapped(
            RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => '_' + (m.group(0) ?? ""))
        .toLowerCase();

    final params = <String, Object>{};
    for (int i = 1; i <= eventParts.length - 2; i += 2) {
      params[eventParts[i]] = eventParts[i + 1];
    }
    return [EventData(name: name, params: params)];
  }
}
