
import 'package:equatable/equatable.dart';

abstract class Trackable  extends Equatable {
  String get analyticTag;
  Map<String, Object> get analyticParams;

  @override
  List<Object> get props => analyticParams.values.toList();
}