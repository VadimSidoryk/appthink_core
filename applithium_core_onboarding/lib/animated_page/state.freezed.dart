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
class _$AnimatedPageStateTearOff {
  const _$AnimatedPageStateTearOff();

  _AnimatedPageState call({int index = 0, int stepsCount = 0, dynamic error}) {
    return _AnimatedPageState(
      index: index,
      stepsCount: stepsCount,
      error: error,
    );
  }
}

/// @nodoc
const $AnimatedPageState = _$AnimatedPageStateTearOff();

/// @nodoc
mixin _$AnimatedPageState {
  int get index => throw _privateConstructorUsedError;
  int get stepsCount => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnimatedPageStateCopyWith<AnimatedPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimatedPageStateCopyWith<$Res> {
  factory $AnimatedPageStateCopyWith(
          AnimatedPageState value, $Res Function(AnimatedPageState) then) =
      _$AnimatedPageStateCopyWithImpl<$Res>;
  $Res call({int index, int stepsCount, dynamic error});
}

/// @nodoc
class _$AnimatedPageStateCopyWithImpl<$Res>
    implements $AnimatedPageStateCopyWith<$Res> {
  _$AnimatedPageStateCopyWithImpl(this._value, this._then);

  final AnimatedPageState _value;
  // ignore: unused_field
  final $Res Function(AnimatedPageState) _then;

  @override
  $Res call({
    Object? index = freezed,
    Object? stepsCount = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      stepsCount: stepsCount == freezed
          ? _value.stepsCount
          : stepsCount // ignore: cast_nullable_to_non_nullable
              as int,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$AnimatedPageStateCopyWith<$Res>
    implements $AnimatedPageStateCopyWith<$Res> {
  factory _$AnimatedPageStateCopyWith(
          _AnimatedPageState value, $Res Function(_AnimatedPageState) then) =
      __$AnimatedPageStateCopyWithImpl<$Res>;
  @override
  $Res call({int index, int stepsCount, dynamic error});
}

/// @nodoc
class __$AnimatedPageStateCopyWithImpl<$Res>
    extends _$AnimatedPageStateCopyWithImpl<$Res>
    implements _$AnimatedPageStateCopyWith<$Res> {
  __$AnimatedPageStateCopyWithImpl(
      _AnimatedPageState _value, $Res Function(_AnimatedPageState) _then)
      : super(_value, (v) => _then(v as _AnimatedPageState));

  @override
  _AnimatedPageState get _value => super._value as _AnimatedPageState;

  @override
  $Res call({
    Object? index = freezed,
    Object? stepsCount = freezed,
    Object? error = freezed,
  }) {
    return _then(_AnimatedPageState(
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      stepsCount: stepsCount == freezed
          ? _value.stepsCount
          : stepsCount // ignore: cast_nullable_to_non_nullable
              as int,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$_AnimatedPageState extends _AnimatedPageState {
  const _$_AnimatedPageState({this.index = 0, this.stepsCount = 0, this.error})
      : super._();

  @JsonKey(defaultValue: 0)
  @override
  final int index;
  @JsonKey(defaultValue: 0)
  @override
  final int stepsCount;
  @override
  final dynamic error;

  @override
  String toString() {
    return 'AnimatedPageState(index: $index, stepsCount: $stepsCount, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AnimatedPageState &&
            (identical(other.index, index) ||
                const DeepCollectionEquality().equals(other.index, index)) &&
            (identical(other.stepsCount, stepsCount) ||
                const DeepCollectionEquality()
                    .equals(other.stepsCount, stepsCount)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(index) ^
      const DeepCollectionEquality().hash(stepsCount) ^
      const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$AnimatedPageStateCopyWith<_AnimatedPageState> get copyWith =>
      __$AnimatedPageStateCopyWithImpl<_AnimatedPageState>(this, _$identity);
}

abstract class _AnimatedPageState extends AnimatedPageState {
  const factory _AnimatedPageState({int index, int stepsCount, dynamic error}) =
      _$_AnimatedPageState;
  const _AnimatedPageState._() : super._();

  @override
  int get index => throw _privateConstructorUsedError;
  @override
  int get stepsCount => throw _privateConstructorUsedError;
  @override
  dynamic get error => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AnimatedPageStateCopyWith<_AnimatedPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
