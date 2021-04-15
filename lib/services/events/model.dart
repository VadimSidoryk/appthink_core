import 'package:equatable/equatable.dart';

class EventTriggerModel extends Equatable {
  static const String _eventNameKey = "event";
  static const String _operatorKey = "operator";
  static const String _countKey = "count";

  final String eventName;
  final Operator operator;
  final int count;

  factory EventTriggerModel.fromMap(Map<String, dynamic> map) {
    return EventTriggerModel(map[_eventNameKey], _parseOperator(map[_operatorKey]), map[_countKey]);
  }

  EventTriggerModel(this.eventName, this.operator, this.count);

  Map<String, dynamic> toMap() {
    return {
      _eventNameKey: eventName,
      _operatorKey: operator.toString(),
      _countKey: count
    };
  }

  @override
  List<Object> get props => [eventName, count, operator];
}

enum Operator { equals, mod, greater }

Operator _parseOperator(String stringValue) {
  return Operator.values
      .firstWhere((value) => value.toString() == stringValue, orElse: () => Operator.mod);
}