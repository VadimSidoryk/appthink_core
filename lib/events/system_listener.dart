import 'package:flutter/cupertino.dart';

import 'base_event.dart';
import 'events_listener.dart';

abstract class SystemListener extends EventsListener<AplEvent> {
  List<NavigatorObserver> get navigatorObservers;
}