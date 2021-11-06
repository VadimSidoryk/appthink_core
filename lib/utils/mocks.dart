import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FieldType<T> extends Equatable {
  Type asDartType();
}

class ObjectType<T> extends FieldType<T> {
  final Type type;

  @visibleForTesting
  ObjectType(this.type);

  @override
  Type asDartType() => type;

  @override
  List<Object?> get props => [type];
}

class ListType<T> extends FieldType<List<T>> {
  final Type itemType;

  @visibleForTesting
  ListType(this.itemType);

  @override
  Type asDartType() => List;

  @override
  List<Object?> get props => [itemType];
}

class SetType<T> extends FieldType<Set<T>> {
  final Type itemType;

  @visibleForTesting
  SetType(this.itemType);

  @override
  Type asDartType() => Set;

  @override
  List<Object?> get props => [itemType];
}

class MapType<K, V> extends FieldType<Map<K, V>> {
  final Type keyType;
  final Type valueType;

  @visibleForTesting
  MapType(this.keyType, this.valueType);

  @override
  Type asDartType() => Map;

  @override
  List<Object?> get props => [keyType, valueType];
}

class FieldToGenerate<T> extends Equatable {
  final int index;
  final FieldType<T> type;
  final bool Function(T)? rule;

  FieldToGenerate._(
      {required this.index, required this.type, required this.rule});

  @override
  List<Object?> get props => [index, type];
}

abstract class _ValueProvider {
  dynamic getValueFor(FieldToGenerate fieldToGenerate);
}

class _DefaultsValueProvider extends _ValueProvider {
  final Map<Type, dynamic> _map;

  _DefaultsValueProvider(this._map);

  @override
  getValueFor(FieldToGenerate fieldToGenerate) {
    final type = fieldToGenerate.type.asDartType();
    final result = _map[type];
    return result;
  }
}

class _MockedValueProvider extends _ValueProvider {
  final Map<FieldToGenerate, dynamic> _values;

  _MockedValueProvider(this._values);

  @override
  getValueFor(FieldToGenerate fieldToGenerate) {
    return _values[fieldToGenerate];
  }
}

abstract class MockGenerator {
  T? nullable<T>({bool Function(T?)? rule});

  T notNull<T>({bool Function(T)? rule});

  List<T?>? nullableList<T>({bool Function(List<dynamic>?)? rule});

  List<T?> notNullList<T>({bool Function(List<dynamic>)? rule});

  Set<T?>? nullableSet<T>({bool Function(Set<dynamic>?)? rule});

  Set<T?> notNullSet<T>({bool Function(Set<dynamic>?)? rule});

  Map<K, V>? nullableMap<K, V>({bool Function(Map<dynamic, dynamic>?)? rule});

  Map<K, V> notNullMap<K, V>({bool Function(Map<dynamic, dynamic>?)? rule});
}

class EmptyMockGenerator extends MockGenerator {
  EmptyMockGenerator._();

  @override
  T notNull<T>({bool Function(T p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  T? nullable<T>({bool Function(T? p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  List<T> notNullList<T>({bool Function(List p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  List<T?>? nullableList<T>({bool Function(List? p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  Map<K, V> notNullMap<K, V>({bool Function(Map? p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  Set<T> notNullSet<T>({bool Function(Set? p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  Map<K, V>? nullableMap<K, V>({bool Function(Map? p1)? rule}) {
    throw UnimplementedError();
  }

  @override
  Set<T>? nullableSet<T>({bool Function(Set? p1)? rule}) {
    throw UnimplementedError();
  }
}

class MockGeneratorImpl extends MockGenerator {
  final _ValueProvider valueProvider;
  final Function(FieldToGenerate)? onParam;
  int fieldIndex = 0;

  MockGeneratorImpl._(this.valueProvider, {this.onParam});

  T? nullable<T>({bool Function(T?)? rule}) {
    return _getImpl((it) => rule?.call(it) ?? true);
  }

  T notNull<T>({bool Function(T)? rule}) {
    return _getImpl<T>((it) => it != null && (rule?.call(it) ?? true))!;
  }

  T? _getImpl<T>(bool Function(T?)? rule) {
    final fieldToGenerate = FieldToGenerate._(
        index: fieldIndex++,
        type: ObjectType<T>(T),
        rule: rule != null ? ((value) => rule.call(value as T?)) : null);
    onParam?.call(fieldToGenerate);
    final result = valueProvider.getValueFor(fieldToGenerate);
    return result;
  }

  List<T?>? nullableList<T>({bool Function(List<dynamic>?)? rule}) {
    return _getListImpl<T>((it) => rule?.call(it) ?? true);
  }

  List<T?> notNullList<T>({bool Function(List<dynamic>)? rule}) {
    return _getListImpl<T>((it) => it != null && (rule?.call(it) ?? true))!;
  }

  List<T?>? _getListImpl<T>(bool Function(List<dynamic>?)? rule) {
    final fieldToGenerate = FieldToGenerate._(
        index: fieldIndex++,
        type: ListType(T),
        rule: rule != null
            ? ((value) => rule.call(value as List<dynamic>?))
            : null);
    onParam?.call(fieldToGenerate);
    try {
      return (valueProvider.getValueFor(fieldToGenerate) as List<dynamic>?)
          ?.map((it) => it as T?)
          .toList();
    } catch(e) {
      throw e;
    }
  }

  Set<T>? nullableSet<T>({bool Function(Set<dynamic>?)? rule}) {
    return _getSetImpl<T>((it) => rule?.call(it) ?? true);
  }

  Set<T> notNullSet<T>({bool Function(Set<dynamic>?)? rule}) {
    return _getSetImpl<T>((it) => it != null && (rule?.call(it) ?? true))!;
  }

  Set<T>? _getSetImpl<T>(bool Function(Set<T?>?)? rule) {
    final fieldToGenerate = FieldToGenerate._(
        index: fieldIndex++,
        type: SetType(T),
        rule: rule != null ? ((value) => rule.call(value as Set<T>)) : null);
    onParam?.call(fieldToGenerate);
    return (valueProvider.getValueFor(fieldToGenerate) as Set<dynamic>?)
        ?.map((it) => it as T)
        .toSet();
  }

  Map<K, V>? nullableMap<K, V>({bool Function(Map<dynamic, dynamic>?)? rule}) {
    return _getMapImpl<K, V>((it) => rule?.call(it) ?? true);
  }

  Map<K, V> notNullMap<K, V>({bool Function(Map<dynamic, dynamic>?)? rule}) {
    return _getMapImpl<K, V>((it) => it != null && (rule?.call(it) ?? true))!;
  }

  Map<K, V>? _getMapImpl<K, V>(bool Function(Map<K, V>?)? rule) {
    final fieldToGenerate = FieldToGenerate._(
        index: fieldIndex++,
        type: MapType(K, V),
        rule:
            rule != null ? ((value) => rule.call(value as Map<K, V>?)) : null);
    onParam?.call(fieldToGenerate);
    return (valueProvider.getValueFor(fieldToGenerate) as Map<dynamic, dynamic>?)
        ?.map((key, value) => MapEntry(key as K, value as V));
  }
}

class MocksFactory {
  final Map<Type, List<dynamic>> _valuesSet = {
    bool: [null, false, true],
    int: [
      null,
      -123123123123,
      -2455,
      -1233,
      -123,
      -12,
      -3,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      14,
      56,
      120,
      2000,
      12000,
      123144312323
    ],
    double: [
      null,
      -double.maxFinite,
      -123123.321,
      -123.2,
      -40,
      2,
      -10,
      0.0,
      double.maxFinite,
      0.001,
      0.1,
      1,
      1.5,
      2,
      2.5,
      3,
      3.5,
      15.5,
      200.42,
      2345.2433,
      double.infinity
    ],
    String: [
      null,
      "",
      "S",
      "Short",
      "Two words",
      "With emojis 👻 💀 ☠️ 👽 👾 🤖 🎃 😺",
      "Do not work for corporations. Old corporations were meaningful when their founders were alive, Do not work for corporations. Old corporations were meaningful when their founders were alive, Do not work for corporations. Old corporations were meaningful when their founders were alive, Do not work for corporations. Old corporations were meaningful when their founders were alive,",
      "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
    ]
  };

  @visibleForTesting
  final Map<Type, dynamic> defaultValues = {
    bool: false,
    int: 0,
    double: 0.0,
    String: "",
    List: [],
    Map: {},
    Set: Set()
  };

  final Map<Type, List<FieldToGenerate>> _fieldsToGenerate = {};
  final Map<Type, Function(MockGenerator)> _generators = {};

  void setValues<T>(List<T> values) {
    _valuesSet[T] = values;
  }

  void addGenerator<T>(T Function(MockGenerator) mocker) {
    List<FieldToGenerate> fieldToGenerate = [];
    final defaultValue = mocker.call(MockGeneratorImpl._(
        _DefaultsValueProvider(defaultValues), onParam: (field) {
      fieldToGenerate.add(field);
    }));
    defaultValues[T] = defaultValue;
    _fieldsToGenerate[T] = fieldToGenerate;
    _generators[T] = mocker;
  }

  List<T?> listAllVariantsOf<T>(Type type) {
    if (_valuesSet.containsKey(type)) {
      return _valuesSet[type]!.map((item) => item as T?).toList();
    } else if (_generators.containsKey(type)) {
      final Map<FieldToGenerate, List<T>> paramValuesRanges =
          getValuesRangeType<T>(type);
      final random = Random();
      final result = <T?>[null];
      final fieldsToGenerate = _fieldsToGenerate[type]!;
      if (fieldsToGenerate.isNotEmpty) {
        for (FieldToGenerate targetField in fieldsToGenerate) {
          for (final targetFieldValue in paramValuesRanges[targetField]!) {
            final Map<FieldToGenerate, dynamic> testingValuesSet =
                paramValuesRanges.map((key, value) => MapEntry(
                    key,
                    value[value.length > 1
                        ? random.nextInt(value.length - 1)
                        : 0]))
                  ..[targetField] = targetFieldValue;
            result.add(_generators[type]!.call(
                MockGeneratorImpl._(_MockedValueProvider(testingValuesSet))));
          }
        }
      } else {
        final generator = _generators[type]!;
        final value = generator.call(EmptyMockGenerator._());
        result.add(value);
      }
      _valuesSet[type] = result;
      return List.from(result.map((item) => item as T?));
    } else {
      throw "Can't find values for type: $type";
    }
  }

  @visibleForTesting
  Map<FieldToGenerate, List<T>> getValuesRangeType<T>(Type type) {
    final result = <FieldToGenerate, List<T>>{};
    for (FieldToGenerate field in _fieldsToGenerate[type]!) {
      final range = getValuesRangeForField(field.type);
      if (field.rule == null) {
        result[field] = range.map((it) => it as T).toList();
      } else {
        final List<T> casted = range.map((it) => it as T).toList();
        result[field] = casted.where(field.rule!).toList();
      }
    }
    return result;
  }

  @visibleForTesting
  List<T?> getValuesRangeForField<T>(FieldType fieldType) {
    if (fieldType is ListType) {
      final range = listAllVariantsOf(fieldType.itemType);
      return <T?>[
        null,
        [] as T,
        [null] as T,
        [range[1]] as T,
        range as T
      ];
    } else if (fieldType is SetType) {
      final range = listAllVariantsOf(fieldType.itemType);
      final Set setWithNull = Set()..add(null);
      final Set setWithOne = Set()..add(range[1]);
      return <T?>[
        null,
        Set() as T,
        setWithNull as T,
        setWithOne as T,
        range.toSet() as T
      ];
    } else if (fieldType is MapType) {
      final keyRange = listAllVariantsOf(fieldType.keyType);
      final valueRange = listAllVariantsOf(fieldType.valueType);

      final List<MapEntry> entries = keyRange
          .map((key) => valueRange.map((value) => MapEntry(key, value)))
          .expand((i) => i)
          .toList();

      return <T?>[
        null,
        {} as T,
        {null: null} as T,
        {keyRange[1]: valueRange[1]} as T,
        Map.fromEntries(entries) as T
      ];
    } else {
      return listAllVariantsOf<T>((fieldType as ObjectType).type);
    }
  }
}
