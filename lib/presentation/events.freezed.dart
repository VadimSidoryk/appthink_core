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
class _$BaseWidgetEventsTearOff {
  const _$BaseWidgetEventsTearOff();

  ScreenCreatedEvent<M> screenCreated<M>(State<StatefulWidget> screenState) {
    return ScreenCreatedEvent<M>(
      screenState,
    );
  }

  ScreenTransition<M> screenTransition<M>(String? from, String to) {
    return ScreenTransition<M>(
      from,
      to,
    );
  }

  ChangingInternalState<M> changeStateWith<M>(dynamic Function(M) changer) {
    return ChangingInternalState<M>(
      changer,
    );
  }

  ScreenDestroyedEvent<M> screenDestroyed<M>(
      State<StatefulWidget> screenState) {
    return ScreenDestroyedEvent<M>(
      screenState,
    );
  }
}

/// @nodoc
const $BaseWidgetEvents = _$BaseWidgetEventsTearOff();

/// @nodoc
mixin _$BaseWidgetEvents<M> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State<StatefulWidget> screenState) screenCreated,
    required TResult Function(String? from, String to) screenTransition,
    required TResult Function(dynamic Function(M) changer) changeStateWith,
    required TResult Function(State<StatefulWidget> screenState)
        screenDestroyed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScreenCreatedEvent<M> value) screenCreated,
    required TResult Function(ScreenTransition<M> value) screenTransition,
    required TResult Function(ChangingInternalState<M> value) changeStateWith,
    required TResult Function(ScreenDestroyedEvent<M> value) screenDestroyed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseWidgetEventsCopyWith<M, $Res> {
  factory $BaseWidgetEventsCopyWith(
          BaseWidgetEvents<M> value, $Res Function(BaseWidgetEvents<M>) then) =
      _$BaseWidgetEventsCopyWithImpl<M, $Res>;
}

/// @nodoc
class _$BaseWidgetEventsCopyWithImpl<M, $Res>
    implements $BaseWidgetEventsCopyWith<M, $Res> {
  _$BaseWidgetEventsCopyWithImpl(this._value, this._then);

  final BaseWidgetEvents<M> _value;
  // ignore: unused_field
  final $Res Function(BaseWidgetEvents<M>) _then;
}

/// @nodoc
abstract class $ScreenCreatedEventCopyWith<M, $Res> {
  factory $ScreenCreatedEventCopyWith(ScreenCreatedEvent<M> value,
          $Res Function(ScreenCreatedEvent<M>) then) =
      _$ScreenCreatedEventCopyWithImpl<M, $Res>;
  $Res call({State<StatefulWidget> screenState});
}

/// @nodoc
class _$ScreenCreatedEventCopyWithImpl<M, $Res>
    extends _$BaseWidgetEventsCopyWithImpl<M, $Res>
    implements $ScreenCreatedEventCopyWith<M, $Res> {
  _$ScreenCreatedEventCopyWithImpl(
      ScreenCreatedEvent<M> _value, $Res Function(ScreenCreatedEvent<M>) _then)
      : super(_value, (v) => _then(v as ScreenCreatedEvent<M>));

  @override
  ScreenCreatedEvent<M> get _value => super._value as ScreenCreatedEvent<M>;

  @override
  $Res call({
    Object? screenState = freezed,
  }) {
    return _then(ScreenCreatedEvent<M>(
      screenState == freezed
          ? _value.screenState
          : screenState // ignore: cast_nullable_to_non_nullable
              as State<StatefulWidget>,
    ));
  }
}

/// @nodoc

class _$ScreenCreatedEvent<M> implements ScreenCreatedEvent<M> {
  _$ScreenCreatedEvent(this.screenState);

  @override
  final State<StatefulWidget> screenState;

  @override
  String toString() {
    return 'BaseWidgetEvents<$M>.screenCreated(screenState: $screenState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ScreenCreatedEvent<M> &&
            (identical(other.screenState, screenState) ||
                const DeepCollectionEquality()
                    .equals(other.screenState, screenState)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(screenState);

  @JsonKey(ignore: true)
  @override
  $ScreenCreatedEventCopyWith<M, ScreenCreatedEvent<M>> get copyWith =>
      _$ScreenCreatedEventCopyWithImpl<M, ScreenCreatedEvent<M>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State<StatefulWidget> screenState) screenCreated,
    required TResult Function(String? from, String to) screenTransition,
    required TResult Function(dynamic Function(M) changer) changeStateWith,
    required TResult Function(State<StatefulWidget> screenState)
        screenDestroyed,
  }) {
    return screenCreated(screenState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
  }) {
    return screenCreated?.call(screenState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (screenCreated != null) {
      return screenCreated(screenState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScreenCreatedEvent<M> value) screenCreated,
    required TResult Function(ScreenTransition<M> value) screenTransition,
    required TResult Function(ChangingInternalState<M> value) changeStateWith,
    required TResult Function(ScreenDestroyedEvent<M> value) screenDestroyed,
  }) {
    return screenCreated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
  }) {
    return screenCreated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (screenCreated != null) {
      return screenCreated(this);
    }
    return orElse();
  }
}

abstract class ScreenCreatedEvent<M> implements BaseWidgetEvents<M> {
  factory ScreenCreatedEvent(State<StatefulWidget> screenState) =
      _$ScreenCreatedEvent<M>;

  State<StatefulWidget> get screenState => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreenCreatedEventCopyWith<M, ScreenCreatedEvent<M>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenTransitionCopyWith<M, $Res> {
  factory $ScreenTransitionCopyWith(
          ScreenTransition<M> value, $Res Function(ScreenTransition<M>) then) =
      _$ScreenTransitionCopyWithImpl<M, $Res>;
  $Res call({String? from, String to});
}

/// @nodoc
class _$ScreenTransitionCopyWithImpl<M, $Res>
    extends _$BaseWidgetEventsCopyWithImpl<M, $Res>
    implements $ScreenTransitionCopyWith<M, $Res> {
  _$ScreenTransitionCopyWithImpl(
      ScreenTransition<M> _value, $Res Function(ScreenTransition<M>) _then)
      : super(_value, (v) => _then(v as ScreenTransition<M>));

  @override
  ScreenTransition<M> get _value => super._value as ScreenTransition<M>;

  @override
  $Res call({
    Object? from = freezed,
    Object? to = freezed,
  }) {
    return _then(ScreenTransition<M>(
      from == freezed
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String?,
      to == freezed
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ScreenTransition<M> implements ScreenTransition<M> {
  _$ScreenTransition(this.from, this.to);

  @override
  final String? from;
  @override
  final String to;

  @override
  String toString() {
    return 'BaseWidgetEvents<$M>.screenTransition(from: $from, to: $to)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ScreenTransition<M> &&
            (identical(other.from, from) ||
                const DeepCollectionEquality().equals(other.from, from)) &&
            (identical(other.to, to) ||
                const DeepCollectionEquality().equals(other.to, to)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(from) ^
      const DeepCollectionEquality().hash(to);

  @JsonKey(ignore: true)
  @override
  $ScreenTransitionCopyWith<M, ScreenTransition<M>> get copyWith =>
      _$ScreenTransitionCopyWithImpl<M, ScreenTransition<M>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State<StatefulWidget> screenState) screenCreated,
    required TResult Function(String? from, String to) screenTransition,
    required TResult Function(dynamic Function(M) changer) changeStateWith,
    required TResult Function(State<StatefulWidget> screenState)
        screenDestroyed,
  }) {
    return screenTransition(from, to);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
  }) {
    return screenTransition?.call(from, to);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (screenTransition != null) {
      return screenTransition(from, to);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScreenCreatedEvent<M> value) screenCreated,
    required TResult Function(ScreenTransition<M> value) screenTransition,
    required TResult Function(ChangingInternalState<M> value) changeStateWith,
    required TResult Function(ScreenDestroyedEvent<M> value) screenDestroyed,
  }) {
    return screenTransition(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
  }) {
    return screenTransition?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (screenTransition != null) {
      return screenTransition(this);
    }
    return orElse();
  }
}

abstract class ScreenTransition<M> implements BaseWidgetEvents<M> {
  factory ScreenTransition(String? from, String to) = _$ScreenTransition<M>;

  String? get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreenTransitionCopyWith<M, ScreenTransition<M>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangingInternalStateCopyWith<M, $Res> {
  factory $ChangingInternalStateCopyWith(ChangingInternalState<M> value,
          $Res Function(ChangingInternalState<M>) then) =
      _$ChangingInternalStateCopyWithImpl<M, $Res>;
  $Res call({dynamic Function(M) changer});
}

/// @nodoc
class _$ChangingInternalStateCopyWithImpl<M, $Res>
    extends _$BaseWidgetEventsCopyWithImpl<M, $Res>
    implements $ChangingInternalStateCopyWith<M, $Res> {
  _$ChangingInternalStateCopyWithImpl(ChangingInternalState<M> _value,
      $Res Function(ChangingInternalState<M>) _then)
      : super(_value, (v) => _then(v as ChangingInternalState<M>));

  @override
  ChangingInternalState<M> get _value =>
      super._value as ChangingInternalState<M>;

  @override
  $Res call({
    Object? changer = freezed,
  }) {
    return _then(ChangingInternalState<M>(
      changer == freezed
          ? _value.changer
          : changer // ignore: cast_nullable_to_non_nullable
              as dynamic Function(M),
    ));
  }
}

/// @nodoc

class _$ChangingInternalState<M> implements ChangingInternalState<M> {
  _$ChangingInternalState(this.changer);

  @override
  final dynamic Function(M) changer;

  @override
  String toString() {
    return 'BaseWidgetEvents<$M>.changeStateWith(changer: $changer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ChangingInternalState<M> &&
            (identical(other.changer, changer) ||
                const DeepCollectionEquality().equals(other.changer, changer)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(changer);

  @JsonKey(ignore: true)
  @override
  $ChangingInternalStateCopyWith<M, ChangingInternalState<M>> get copyWith =>
      _$ChangingInternalStateCopyWithImpl<M, ChangingInternalState<M>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State<StatefulWidget> screenState) screenCreated,
    required TResult Function(String? from, String to) screenTransition,
    required TResult Function(dynamic Function(M) changer) changeStateWith,
    required TResult Function(State<StatefulWidget> screenState)
        screenDestroyed,
  }) {
    return changeStateWith(changer);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
  }) {
    return changeStateWith?.call(changer);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (changeStateWith != null) {
      return changeStateWith(changer);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScreenCreatedEvent<M> value) screenCreated,
    required TResult Function(ScreenTransition<M> value) screenTransition,
    required TResult Function(ChangingInternalState<M> value) changeStateWith,
    required TResult Function(ScreenDestroyedEvent<M> value) screenDestroyed,
  }) {
    return changeStateWith(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
  }) {
    return changeStateWith?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (changeStateWith != null) {
      return changeStateWith(this);
    }
    return orElse();
  }
}

abstract class ChangingInternalState<M> implements BaseWidgetEvents<M> {
  factory ChangingInternalState(dynamic Function(M) changer) =
      _$ChangingInternalState<M>;

  dynamic Function(M) get changer => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChangingInternalStateCopyWith<M, ChangingInternalState<M>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenDestroyedEventCopyWith<M, $Res> {
  factory $ScreenDestroyedEventCopyWith(ScreenDestroyedEvent<M> value,
          $Res Function(ScreenDestroyedEvent<M>) then) =
      _$ScreenDestroyedEventCopyWithImpl<M, $Res>;
  $Res call({State<StatefulWidget> screenState});
}

/// @nodoc
class _$ScreenDestroyedEventCopyWithImpl<M, $Res>
    extends _$BaseWidgetEventsCopyWithImpl<M, $Res>
    implements $ScreenDestroyedEventCopyWith<M, $Res> {
  _$ScreenDestroyedEventCopyWithImpl(ScreenDestroyedEvent<M> _value,
      $Res Function(ScreenDestroyedEvent<M>) _then)
      : super(_value, (v) => _then(v as ScreenDestroyedEvent<M>));

  @override
  ScreenDestroyedEvent<M> get _value => super._value as ScreenDestroyedEvent<M>;

  @override
  $Res call({
    Object? screenState = freezed,
  }) {
    return _then(ScreenDestroyedEvent<M>(
      screenState == freezed
          ? _value.screenState
          : screenState // ignore: cast_nullable_to_non_nullable
              as State<StatefulWidget>,
    ));
  }
}

/// @nodoc

class _$ScreenDestroyedEvent<M> implements ScreenDestroyedEvent<M> {
  _$ScreenDestroyedEvent(this.screenState);

  @override
  final State<StatefulWidget> screenState;

  @override
  String toString() {
    return 'BaseWidgetEvents<$M>.screenDestroyed(screenState: $screenState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ScreenDestroyedEvent<M> &&
            (identical(other.screenState, screenState) ||
                const DeepCollectionEquality()
                    .equals(other.screenState, screenState)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(screenState);

  @JsonKey(ignore: true)
  @override
  $ScreenDestroyedEventCopyWith<M, ScreenDestroyedEvent<M>> get copyWith =>
      _$ScreenDestroyedEventCopyWithImpl<M, ScreenDestroyedEvent<M>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State<StatefulWidget> screenState) screenCreated,
    required TResult Function(String? from, String to) screenTransition,
    required TResult Function(dynamic Function(M) changer) changeStateWith,
    required TResult Function(State<StatefulWidget> screenState)
        screenDestroyed,
  }) {
    return screenDestroyed(screenState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
  }) {
    return screenDestroyed?.call(screenState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State<StatefulWidget> screenState)? screenCreated,
    TResult Function(String? from, String to)? screenTransition,
    TResult Function(dynamic Function(M) changer)? changeStateWith,
    TResult Function(State<StatefulWidget> screenState)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (screenDestroyed != null) {
      return screenDestroyed(screenState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScreenCreatedEvent<M> value) screenCreated,
    required TResult Function(ScreenTransition<M> value) screenTransition,
    required TResult Function(ChangingInternalState<M> value) changeStateWith,
    required TResult Function(ScreenDestroyedEvent<M> value) screenDestroyed,
  }) {
    return screenDestroyed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
  }) {
    return screenDestroyed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScreenCreatedEvent<M> value)? screenCreated,
    TResult Function(ScreenTransition<M> value)? screenTransition,
    TResult Function(ChangingInternalState<M> value)? changeStateWith,
    TResult Function(ScreenDestroyedEvent<M> value)? screenDestroyed,
    required TResult orElse(),
  }) {
    if (screenDestroyed != null) {
      return screenDestroyed(this);
    }
    return orElse();
  }
}

abstract class ScreenDestroyedEvent<M> implements BaseWidgetEvents<M> {
  factory ScreenDestroyedEvent(State<StatefulWidget> screenState) =
      _$ScreenDestroyedEvent<M>;

  State<StatefulWidget> get screenState => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreenDestroyedEventCopyWith<M, ScreenDestroyedEvent<M>> get copyWith =>
      throw _privateConstructorUsedError;
}
