import 'package:applithium_core/events/events_listener.dart';

abstract class Analyst extends EventsListener {

  void setUserProperty(String name, Object? value);

}