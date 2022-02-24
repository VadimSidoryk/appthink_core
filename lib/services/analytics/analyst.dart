import 'package:applithium_core/events/mapper/scheme.dart';
import 'package:applithium_core/events/system_listener.dart';

abstract class Analyst extends SystemListener {

  void setUserProperty(String name, Object? value);

  @override
  void onEvent(EventData event) {
    sendEvent(event.name, event.params);
  }

  void sendEvent(String name, Map<String, Object?>? params);
}

