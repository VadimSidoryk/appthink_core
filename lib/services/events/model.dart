import 'package:equatable/equatable.dart';

class EventTriggerModel extends Equatable {
  static const String _conditionKey = "condition";
  static const String _actionKey = "action";

  final String condition;
  final String action;

  factory EventTriggerModel.fromMap(Map<String, dynamic> map) {
    return EventTriggerModel(map[_conditionKey], map[_actionKey]);
  }

  EventTriggerModel(this.condition, this.action);

  @override
  List<Object> get props => [condition, action];
}

