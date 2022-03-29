import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/mapper/scheme.dart';

class FreezedEventsScheme extends EventsScheme {

  @override
  List<EventData>? mapEventImpl(AplEvent event) {
    final eventString = event.toString();
    final eventParts = eventString.split(new RegExp(r'[,():]'));
    final name = eventParts.length > 1 ? eventParts[0] : "";
    final params = <String, Object>{};
    for(int i = 1; i < eventParts.length - 2; i+=2) {
      params[eventParts[i]] = eventParts[i+1];
    }
    return [EventData(name: name, params: params)];
  }
}