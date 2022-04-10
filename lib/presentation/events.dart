import 'package:applithium_core/events/base_event.dart';
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

  factory BaseWidgetEvents.screenTransition(String? from, String to) =
  ScreenTransition;

  factory BaseWidgetEvents.changeStateWith(Function(M) changer) =
  ChangingInternalState;

  factory BaseWidgetEvents.screenPaused(State screenState) = ScreenPausedEvent;

  factory BaseWidgetEvents.screenDestroyed(State screenState) =
  ScreenDestroyedEvent;
}
