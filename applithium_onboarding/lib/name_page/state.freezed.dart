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
class _$UserNamePageStateTearOff {
  const _$UserNamePageStateTearOff();

  _UserNamePageState call(
      {bool isLoading = false,
      bool isContinueEnabled = false,
      String? userName,
      dynamic error}) {
    return _UserNamePageState(
      isLoading: isLoading,
      isContinueEnabled: isContinueEnabled,
      userName: userName,
      error: error,
    );
  }
}

/// @nodoc
const $UserNamePageState = _$UserNamePageStateTearOff();

/// @nodoc
mixin _$UserNamePageState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isContinueEnabled => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserNamePageStateCopyWith<UserNamePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNamePageStateCopyWith<$Res> {
  factory $UserNamePageStateCopyWith(
          UserNamePageState value, $Res Function(UserNamePageState) then) =
      _$UserNamePageStateCopyWithImpl<$Res>;
  $Res call(
      {bool isLoading,
      bool isContinueEnabled,
      String? userName,
      dynamic error});
}

/// @nodoc
class _$UserNamePageStateCopyWithImpl<$Res>
    implements $UserNamePageStateCopyWith<$Res> {
  _$UserNamePageStateCopyWithImpl(this._value, this._then);

  final UserNamePageState _value;
  // ignore: unused_field
  final $Res Function(UserNamePageState) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isContinueEnabled = freezed,
    Object? userName = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isContinueEnabled: isContinueEnabled == freezed
          ? _value.isContinueEnabled
          : isContinueEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$UserNamePageStateCopyWith<$Res>
    implements $UserNamePageStateCopyWith<$Res> {
  factory _$UserNamePageStateCopyWith(
          _UserNamePageState value, $Res Function(_UserNamePageState) then) =
      __$UserNamePageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isLoading,
      bool isContinueEnabled,
      String? userName,
      dynamic error});
}

/// @nodoc
class __$UserNamePageStateCopyWithImpl<$Res>
    extends _$UserNamePageStateCopyWithImpl<$Res>
    implements _$UserNamePageStateCopyWith<$Res> {
  __$UserNamePageStateCopyWithImpl(
      _UserNamePageState _value, $Res Function(_UserNamePageState) _then)
      : super(_value, (v) => _then(v as _UserNamePageState));

  @override
  _UserNamePageState get _value => super._value as _UserNamePageState;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isContinueEnabled = freezed,
    Object? userName = freezed,
    Object? error = freezed,
  }) {
    return _then(_UserNamePageState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isContinueEnabled: isContinueEnabled == freezed
          ? _value.isContinueEnabled
          : isContinueEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$_UserNamePageState extends _UserNamePageState {
  const _$_UserNamePageState(
      {this.isLoading = false,
      this.isContinueEnabled = false,
      this.userName,
      this.error})
      : super._();

  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;
  @JsonKey(defaultValue: false)
  @override
  final bool isContinueEnabled;
  @override
  final String? userName;
  @override
  final dynamic error;

  @override
  String toString() {
    return 'UserNamePageState(isLoading: $isLoading, isContinueEnabled: $isContinueEnabled, userName: $userName, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserNamePageState &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)) &&
            (identical(other.isContinueEnabled, isContinueEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isContinueEnabled, isContinueEnabled)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality()
                    .equals(other.userName, userName)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isLoading) ^
      const DeepCollectionEquality().hash(isContinueEnabled) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$UserNamePageStateCopyWith<_UserNamePageState> get copyWith =>
      __$UserNamePageStateCopyWithImpl<_UserNamePageState>(this, _$identity);
}

abstract class _UserNamePageState extends UserNamePageState {
  const factory _UserNamePageState(
      {bool isLoading,
      bool isContinueEnabled,
      String? userName,
      dynamic error}) = _$_UserNamePageState;
  const _UserNamePageState._() : super._();

  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  bool get isContinueEnabled => throw _privateConstructorUsedError;
  @override
  String? get userName => throw _privateConstructorUsedError;
  @override
  dynamic get error => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserNamePageStateCopyWith<_UserNamePageState> get copyWith =>
      throw _privateConstructorUsedError;
}
