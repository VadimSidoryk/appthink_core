import 'package:appthink_core/events/base_event.dart';
import 'package:appthink_core/logs/extension.dart';
import 'package:appthink_core/utils/extension.dart';
import 'package:flutter/foundation.dart';

abstract class EventsScheme {
  List<EventData>? mapEvent(AplEvent event) {
    try {
      return mapEventImpl(event);
    } catch (e, stacktrace) {
      logError("mapEvent", e, stacktrace);
      return null;
    }
  }

  @protected
  List<EventData>? mapEventImpl(AplEvent event);
}

class EventData {
  final String name;
  final Map<String, Object>? params;

  EventData({required this.name, this.params});

  Map<String, Object> asArgs() {
    final result = <String, Object>{"name": name, "sender": ""};
    params?.let((it) {
      result.addAll(it);
    });

    return result;
  }
}
