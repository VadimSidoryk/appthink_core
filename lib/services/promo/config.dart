import 'event_trigger.dart';

class PromoConfig {
  final Map<String, Set<AplEventTrigger>> triggers;

  PromoConfig(this.triggers);
}