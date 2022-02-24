import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/mapper/scheme.dart';

class FreezedEventsScheme extends EventsScheme {

  @override
  List<EventData>? mapEventImpl(AplEvent event) {
    final eventString = event.toString();
    final eventParts = eventString.split(".");
    final name = eventParts.length > 1 ? eventParts[1] : "";
    final params = <String, Object>{};
    return [EventData(name: name, params: params)];
  }
}