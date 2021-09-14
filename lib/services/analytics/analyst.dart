import 'package:applithium_core/events/system_listener.dart';

abstract class Analyst extends SystemListener {
  void setUserProperty(String name, Object? value);
}