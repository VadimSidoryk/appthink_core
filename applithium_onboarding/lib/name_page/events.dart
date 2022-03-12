import 'package:applithium_core/presentation/events.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "events.freezed.dart";

@freezed
class UserNamePageEvents extends WidgetEvents with _$UserNamePageEvents {
  factory UserNamePageEvents.continueClicked() = ContinueClicked;
  factory UserNamePageEvents.backClicked() = BackClicked;
  factory UserNamePageEvents.nameChanged(String? name) = NameChanged;
}
