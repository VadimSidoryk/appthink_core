// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AnimatedPageEventTearOff {
  const _$AnimatedPageEventTearOff();

  NextPage nextPage(int currentIndex) {
    return NextPage(
      currentIndex,
    );
  }
}

/// @nodoc
const $AnimatedPageEvent = _$AnimatedPageEventTearOff();

/// @nodoc
mixin _$AnimatedPageEvent {
  int get currentIndex => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentIndex) nextPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int currentIndex)? nextPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentIndex)? nextPage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NextPage value) nextPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NextPage value)? nextPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NextPage value)? nextPage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnimatedPageEventCopyWith<AnimatedPageEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimatedPageEventCopyWith<$Res> {
  factory $AnimatedPageEventCopyWith(
          AnimatedPageEvent value, $Res Function(AnimatedPageEvent) then) =
      _$AnimatedPageEventCopyWithImpl<$Res>;
  $Res call({int currentIndex});
}

/// @nodoc
class _$AnimatedPageEventCopyWithImpl<$Res>
    implements $AnimatedPageEventCopyWith<$Res> {
  _$AnimatedPageEventCopyWithImpl(this._value, this._then);

  final AnimatedPageEvent _value;
  // ignore: unused_field
  final $Res Function(AnimatedPageEvent) _then;

  @override
  $Res call({
    Object? currentIndex = freezed,
  }) {
    return _then(_value.copyWith(
      currentIndex: currentIndex == freezed
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class $NextPageCopyWith<$Res>
    implements $AnimatedPageEventCopyWith<$Res> {
  factory $NextPageCopyWith(NextPage value, $Res Function(NextPage) then) =
      _$NextPageCopyWithImpl<$Res>;
  @override
  $Res call({int currentIndex});
}

/// @nodoc
class _$NextPageCopyWithImpl<$Res> extends _$AnimatedPageEventCopyWithImpl<$Res>
    implements $NextPageCopyWith<$Res> {
  _$NextPageCopyWithImpl(NextPage _value, $Res Function(NextPage) _then)
      : super(_value, (v) => _then(v as NextPage));

  @override
  NextPage get _value => super._value as NextPage;

  @override
  $Res call({
    Object? currentIndex = freezed,
  }) {
    return _then(NextPage(
      currentIndex == freezed
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$NextPage implements NextPage {
  _$NextPage(this.currentIndex);

  @override
  final int currentIndex;

  @override
  String toString() {
    return 'AnimatedPageEvent.nextPage(currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is NextPage &&
            (identical(other.currentIndex, currentIndex) ||
                const DeepCollectionEquality()
                    .equals(other.currentIndex, currentIndex)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(currentIndex);

  @JsonKey(ignore: true)
  @override
  $NextPageCopyWith<NextPage> get copyWith =>
      _$NextPageCopyWithImpl<NextPage>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentIndex) nextPage,
  }) {
    return nextPage(currentIndex);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int currentIndex)? nextPage,
  }) {
    return nextPage?.call(currentIndex);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentIndex)? nextPage,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(currentIndex);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NextPage value) nextPage,
  }) {
    return nextPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NextPage value)? nextPage,
  }) {
    return nextPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NextPage value)? nextPage,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(this);
    }
    return orElse();
  }
}

abstract class NextPage implements AnimatedPageEvent {
  factory NextPage(int currentIndex) = _$NextPage;

  @override
  int get currentIndex => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $NextPageCopyWith<NextPage> get copyWith =>
      throw _privateConstructorUsedError;
}
