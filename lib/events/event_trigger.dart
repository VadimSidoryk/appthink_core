import 'package:applithium_core/events/action.dart';
import 'package:equatable/equatable.dart';

class AplEventTrigger extends Equatable {
  static const String _conditionKey = "condition";
  static const String _actionKey = "action";

  final String condition;
  final AplAction action;

  factory AplEventTrigger.fromMap(Map<String, dynamic> map) {
    return AplEventTrigger(map[_conditionKey], map[_actionKey]);
  }

  AplEventTrigger(this.condition, this.action);

  @override
  List<Object> get props => [condition, action];
}
