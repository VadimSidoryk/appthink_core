import 'package:applithium_core/presentation/state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class AnimatedPageState extends BaseState with _$AnimatedPageState {
  const AnimatedPageState._() : super();

  const factory AnimatedPageState(
      {@Default(0) int index,
      @Default(0) int stepsCount,
      dynamic error}) = _AnimatedPageState;

  @override
  BaseState withError(error) {
    return copyWith(error: error);
  }
}
