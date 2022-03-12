// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UserPhotoPageStateTearOff {
  const _$UserPhotoPageStateTearOff();

  _UserPhotoPageState call(
      {bool isLoading = false, String photoPath = "", dynamic error}) {
    return _UserPhotoPageState(
      isLoading: isLoading,
      photoPath: photoPath,
      error: error,
    );
  }
}

/// @nodoc
const $UserPhotoPageState = _$UserPhotoPageStateTearOff();

/// @nodoc
mixin _$UserPhotoPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  String get photoPath => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserPhotoPageStateCopyWith<UserPhotoPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPhotoPageStateCopyWith<$Res> {
  factory $UserPhotoPageStateCopyWith(
          UserPhotoPageState value, $Res Function(UserPhotoPageState) then) =
      _$UserPhotoPageStateCopyWithImpl<$Res>;
  $Res call({bool isLoading, String photoPath, dynamic error});
}

/// @nodoc
class _$UserPhotoPageStateCopyWithImpl<$Res>
    implements $UserPhotoPageStateCopyWith<$Res> {
  _$UserPhotoPageStateCopyWithImpl(this._value, this._then);

  final UserPhotoPageState _value;
  // ignore: unused_field
  final $Res Function(UserPhotoPageState) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? photoPath = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      photoPath: photoPath == freezed
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$UserPhotoPageStateCopyWith<$Res>
    implements $UserPhotoPageStateCopyWith<$Res> {
  factory _$UserPhotoPageStateCopyWith(
          _UserPhotoPageState value, $Res Function(_UserPhotoPageState) then) =
      __$UserPhotoPageStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isLoading, String photoPath, dynamic error});
}

/// @nodoc
class __$UserPhotoPageStateCopyWithImpl<$Res>
    extends _$UserPhotoPageStateCopyWithImpl<$Res>
    implements _$UserPhotoPageStateCopyWith<$Res> {
  __$UserPhotoPageStateCopyWithImpl(
      _UserPhotoPageState _value, $Res Function(_UserPhotoPageState) _then)
      : super(_value, (v) => _then(v as _UserPhotoPageState));

  @override
  _UserPhotoPageState get _value => super._value as _UserPhotoPageState;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? photoPath = freezed,
    Object? error = freezed,
  }) {
    return _then(_UserPhotoPageState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      photoPath: photoPath == freezed
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$_UserPhotoPageState extends _UserPhotoPageState {
  const _$_UserPhotoPageState(
      {this.isLoading = false, this.photoPath = "", this.error})
      : super._();

  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;
  @JsonKey(defaultValue: "")
  @override
  final String photoPath;
  @override
  final dynamic error;

  @override
  String toString() {
    return 'UserPhotoPageState(isLoading: $isLoading, photoPath: $photoPath, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserPhotoPageState &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)) &&
            (identical(other.photoPath, photoPath) ||
                const DeepCollectionEquality()
                    .equals(other.photoPath, photoPath)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isLoading) ^
      const DeepCollectionEquality().hash(photoPath) ^
      const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$UserPhotoPageStateCopyWith<_UserPhotoPageState> get copyWith =>
      __$UserPhotoPageStateCopyWithImpl<_UserPhotoPageState>(this, _$identity);
}

abstract class _UserPhotoPageState extends UserPhotoPageState {
  const factory _UserPhotoPageState(
      {bool isLoading,
      String photoPath,
      dynamic error}) = _$_UserPhotoPageState;
  const _UserPhotoPageState._() : super._();

  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  String get photoPath => throw _privateConstructorUsedError;
  @override
  dynamic get error => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserPhotoPageStateCopyWith<_UserPhotoPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
