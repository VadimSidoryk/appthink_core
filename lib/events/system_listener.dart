import 'package:applithium_core/events/events_listener.dart';
import 'package:flutter/cupertino.dart';

abstract class SystemListener extends EventsListener {
  NavigatorObserver get navigatorObserver;
}