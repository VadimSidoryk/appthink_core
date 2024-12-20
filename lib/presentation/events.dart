import 'dart:async';

import 'package:appthink_core/events/base_event.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'events.freezed.dart';

abstract class WidgetEvents extends AplEvent {}

@freezed
class BaseWidgetEvents<M> extends WidgetEvents with _$BaseWidgetEvents<M> {
  factory BaseWidgetEvents.screenCreated(State screenState) =
  ScreenCreatedEvent;

  factory BaseWidgetEvents.screenResumed(State screenState) =
  ScreenResumedEvent;

  factory BaseWidgetEvents.showAlert(String title, String description) = ShowAlert;

  factory BaseWidgetEvents.showNonFatalError(dynamic error) = ShowNonFatalError;

  factory BaseWidgetEvents.showAction(String title, String description, Map<String, Function()> actions) = ShowAction;

  factory BaseWidgetEvents.screenTransition(String? from, String to) =
  ScreenTransition;

  factory BaseWidgetEvents.changeStateWith(FutureOr<dynamic> Function(M) changer) =
  ChangingInternalState;

  factory BaseWidgetEvents.screenPaused(State screenState) = ScreenPausedEvent;

  factory BaseWidgetEvents.screenDestroyed(State screenState) =
  ScreenDestroyedEvent;
}
