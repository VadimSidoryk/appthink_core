import 'package:applithium_core/events/mapper/scheme.dart';
import 'package:flutter/cupertino.dart';

import 'events_listener.dart';

abstract class SystemListener extends EventsListener<EventData> {
  List<NavigatorObserver> get navigatorObservers;
}