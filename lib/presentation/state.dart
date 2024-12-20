import 'package:freezed_annotation/freezed_annotation.dart';

abstract class BaseState<M> {

  const BaseState();

  BaseState<M> withFatalError(dynamic fatalError, stackTrace);

  BaseState<M> withNonFatalError(dynamic nonFatalError, stackTrace);

  BaseState<M> withAlert(AlertModel model);

  BaseState<M> withAction(ActionModel<T>);
}

@freezed
class AlertModel {
  final String title;
  final String description;

  AlertModel({required this.title, required this.description});
}

@freezed
class ActionModel<T> {
  final String title;
  final String description;
  final Map<String, Future<T> Function()> actions;

  ActionModel({required this.title, required this.description, required this.actions});
}
