import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:flutter/widgets.dart';

abstract class Analyst extends SystemListener {
  void setUserProperty(String name, Object? value);
}