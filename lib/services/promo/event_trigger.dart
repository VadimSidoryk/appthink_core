
import 'action.dart';

class AplEventTrigger  {
  static const String _conditionKey = "condition";
  static const String _actionKey = "action";

  final String condition;
  final PromoAction action;

  factory AplEventTrigger.fromMap(Map<String, dynamic> map) {
    return AplEventTrigger(map[_conditionKey], map[_actionKey]);
  }

  AplEventTrigger(this.condition, this.action);
}

