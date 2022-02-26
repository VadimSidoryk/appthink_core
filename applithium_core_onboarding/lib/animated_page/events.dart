import 'package:applithium_core/presentation/events.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "events.freezed.dart";

@freezed
class AnimatedPageEvent extends WidgetEvents with _$AnimatedPageEvent {
  factory AnimatedPageEvent.nextPage(int currentIndex) = NextPage;
}
