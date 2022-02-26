import 'package:applithium_core/presentation/state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UserNamePageState extends BaseState with _$UserNamePageState {
  const UserNamePageState._() : super();

  const factory UserNamePageState(
      {@Default(false) bool isLoading,
      @Default(false) bool isContinueEnabled,
      String? userName,
      dynamic error}) = _UserNamePageState;

  @override
  BaseState withError(error) {
    return copyWith(error: error);
  }
}
