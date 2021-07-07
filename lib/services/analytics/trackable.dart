
import 'package:equatable/equatable.dart';

abstract class Trackable  extends Equatable {
  String get name;
  Map<String, Object> get params;

  @override
  List<Object> get props => params.values.toList();
}