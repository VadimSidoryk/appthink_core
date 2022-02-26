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
class _$UserNamePageEventsTearOff {
  const _$UserNamePageEventsTearOff();

  ContinueClicked continueClicked() {
    return ContinueClicked();
  }

  BackClicked backClicked() {
    return BackClicked();
  }

  NameChanged nameChanged(String? name) {
    return NameChanged(
      name,
    );
  }
}

/// @nodoc
const $UserNamePageEvents = _$UserNamePageEventsTearOff();

/// @nodoc
mixin _$UserNamePageEvents {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() continueClicked,
    required TResult Function() backClicked,
    required TResult Function(String? name) nameChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContinueClicked value) continueClicked,
    required TResult Function(BackClicked value) backClicked,
    required TResult Function(NameChanged value) nameChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNamePageEventsCopyWith<$Res> {
  factory $UserNamePageEventsCopyWith(
          UserNamePageEvents value, $Res Function(UserNamePageEvents) then) =
      _$UserNamePageEventsCopyWithImpl<$Res>;
}

/// @nodoc
class _$UserNamePageEventsCopyWithImpl<$Res>
    implements $UserNamePageEventsCopyWith<$Res> {
  _$UserNamePageEventsCopyWithImpl(this._value, this._then);

  final UserNamePageEvents _value;
  // ignore: unused_field
  final $Res Function(UserNamePageEvents) _then;
}

/// @nodoc
abstract class $ContinueClickedCopyWith<$Res> {
  factory $ContinueClickedCopyWith(
          ContinueClicked value, $Res Function(ContinueClicked) then) =
      _$ContinueClickedCopyWithImpl<$Res>;
}

/// @nodoc
class _$ContinueClickedCopyWithImpl<$Res>
    extends _$UserNamePageEventsCopyWithImpl<$Res>
    implements $ContinueClickedCopyWith<$Res> {
  _$ContinueClickedCopyWithImpl(
      ContinueClicked _value, $Res Function(ContinueClicked) _then)
      : super(_value, (v) => _then(v as ContinueClicked));

  @override
  ContinueClicked get _value => super._value as ContinueClicked;
}

/// @nodoc

class _$ContinueClicked implements ContinueClicked {
  _$ContinueClicked();

  @override
  String toString() {
    return 'UserNamePageEvents.continueClicked()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is ContinueClicked);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() continueClicked,
    required TResult Function() backClicked,
    required TResult Function(String? name) nameChanged,
  }) {
    return continueClicked();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
  }) {
    return continueClicked?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
    required TResult orElse(),
  }) {
    if (continueClicked != null) {
      return continueClicked();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContinueClicked value) continueClicked,
    required TResult Function(BackClicked value) backClicked,
    required TResult Function(NameChanged value) nameChanged,
  }) {
    return continueClicked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
  }) {
    return continueClicked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
    required TResult orElse(),
  }) {
    if (continueClicked != null) {
      return continueClicked(this);
    }
    return orElse();
  }
}

abstract class ContinueClicked implements UserNamePageEvents {
  factory ContinueClicked() = _$ContinueClicked;
}

/// @nodoc
abstract class $BackClickedCopyWith<$Res> {
  factory $BackClickedCopyWith(
          BackClicked value, $Res Function(BackClicked) then) =
      _$BackClickedCopyWithImpl<$Res>;
}

/// @nodoc
class _$BackClickedCopyWithImpl<$Res>
    extends _$UserNamePageEventsCopyWithImpl<$Res>
    implements $BackClickedCopyWith<$Res> {
  _$BackClickedCopyWithImpl(
      BackClicked _value, $Res Function(BackClicked) _then)
      : super(_value, (v) => _then(v as BackClicked));

  @override
  BackClicked get _value => super._value as BackClicked;
}

/// @nodoc

class _$BackClicked implements BackClicked {
  _$BackClicked();

  @override
  String toString() {
    return 'UserNamePageEvents.backClicked()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is BackClicked);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() continueClicked,
    required TResult Function() backClicked,
    required TResult Function(String? name) nameChanged,
  }) {
    return backClicked();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
  }) {
    return backClicked?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
    required TResult orElse(),
  }) {
    if (backClicked != null) {
      return backClicked();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContinueClicked value) continueClicked,
    required TResult Function(BackClicked value) backClicked,
    required TResult Function(NameChanged value) nameChanged,
  }) {
    return backClicked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
  }) {
    return backClicked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
    required TResult orElse(),
  }) {
    if (backClicked != null) {
      return backClicked(this);
    }
    return orElse();
  }
}

abstract class BackClicked implements UserNamePageEvents {
  factory BackClicked() = _$BackClicked;
}

/// @nodoc
abstract class $NameChangedCopyWith<$Res> {
  factory $NameChangedCopyWith(
          NameChanged value, $Res Function(NameChanged) then) =
      _$NameChangedCopyWithImpl<$Res>;
  $Res call({String? name});
}

/// @nodoc
class _$NameChangedCopyWithImpl<$Res>
    extends _$UserNamePageEventsCopyWithImpl<$Res>
    implements $NameChangedCopyWith<$Res> {
  _$NameChangedCopyWithImpl(
      NameChanged _value, $Res Function(NameChanged) _then)
      : super(_value, (v) => _then(v as NameChanged));

  @override
  NameChanged get _value => super._value as NameChanged;

  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(NameChanged(
      name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NameChanged implements NameChanged {
  _$NameChanged(this.name);

  @override
  final String? name;

  @override
  String toString() {
    return 'UserNamePageEvents.nameChanged(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is NameChanged &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(name);

  @JsonKey(ignore: true)
  @override
  $NameChangedCopyWith<NameChanged> get copyWith =>
      _$NameChangedCopyWithImpl<NameChanged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() continueClicked,
    required TResult Function() backClicked,
    required TResult Function(String? name) nameChanged,
  }) {
    return nameChanged(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
  }) {
    return nameChanged?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? continueClicked,
    TResult Function()? backClicked,
    TResult Function(String? name)? nameChanged,
    required TResult orElse(),
  }) {
    if (nameChanged != null) {
      return nameChanged(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContinueClicked value) continueClicked,
    required TResult Function(BackClicked value) backClicked,
    required TResult Function(NameChanged value) nameChanged,
  }) {
    return nameChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
  }) {
    return nameChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContinueClicked value)? continueClicked,
    TResult Function(BackClicked value)? backClicked,
    TResult Function(NameChanged value)? nameChanged,
    required TResult orElse(),
  }) {
    if (nameChanged != null) {
      return nameChanged(this);
    }
    return orElse();
  }
}

abstract class NameChanged implements UserNamePageEvents {
  factory NameChanged(String? name) = _$NameChanged;

  String? get name => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NameChangedCopyWith<NameChanged> get copyWith =>
      throw _privateConstructorUsedError;
}
