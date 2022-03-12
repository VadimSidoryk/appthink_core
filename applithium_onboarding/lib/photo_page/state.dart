import 'package:applithium_core/presentation/state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UserPhotoPageState extends BaseState with _$UserPhotoPageState {
  const UserPhotoPageState._() : super();

  const factory UserPhotoPageState(
      {@Default(false) bool isLoading,
      @Default("") String photoPath,
      dynamic error}) = _UserPhotoPageState;

  @override
  BaseState withError(error) {
    return copyWith(error: error);
  }
}
