import 'dart:math';

enum Collection { List, Map, Set }

class GeneratedParam {
  final Type forType;
  final Collection? collectionType;
  final bool Function(dynamic)? rule;

  GeneratedParam._({required this.forType, required this.rule, required this.collectionType});
}

abstract class _ValueProvider {
  dynamic getValueFor(Type type);
}

class _MapValueProvider extends _ValueProvider {
  final Map<Type, dynamic> _map;

  _MapValueProvider(this._map);

  @override
  getValueFor(Type type) {
    return _map[type];
  }
}

class _ListValueProvider extends _ValueProvider {
  final List<dynamic> _list;
  var _index = 0;

  _ListValueProvider(this._list);

  @override
  getValueFor(Type type) {
    return _list[_index++];
  }
}

class MockGenerator {
  final _ValueProvider valueProvider;
  final Function(GeneratedParam)? onParam;

  MockGenerator._({required this.valueProvider, this.onParam});

  T? getWithRule<T>(bool Function(T?)? rule) {
    onParam?.call(GeneratedParam._(
      forType: T,
        rule: rule != null ? ((value) => rule.call(value as T?)) : null,
        collectionType: null));
    return valueProvider.getValueFor(T);
  }

  T? getNullable<T>() {
    return getWithRule(null);
  }

  T getNotNull<T>() {
    return getWithRule<T>((it) => it != null)!;
  }

  List<T> getListWithRule<T>(bool Function(T?)? rule) {
    onParam?.call(GeneratedParam._(
      forType: T,
        rule: rule != null ? ((value) => rule.call(value as T?)) : null,
        collectionType: Collection.List));
    return (valueProvider.getValueFor(List) as List<dynamic>)
        .map((it) => it as T)
        .toList();
  }

  Set<T> getSetWithRule<T>(bool Function(List<T?>?)? rule) {
    onParam?.call(GeneratedParam._(
        forType: T,
        rule: rule != null ? ((value) => rule.call(value as List<T?>?)) : null,
        collectionType: Collection.Set));
    return (valueProvider.getValueFor(List) as Set<dynamic>)
        .map((it) => it as T)
        .toSet();
  }
}

class MocksFactory {
  final Map<Type, List<dynamic>> _valuesSet = {
    bool: [false, true, null],
    int: [-123123123123, 0, 123144312323, null],
    double: [-double.maxFinite, 0.0, double.maxFinite, double.infinity, null],
    String: [
      "",
      "S",
      "Short",
      "Two words",
      "With emojis 👻 💀 ☠️ 👽 👾 🤖 🎃 😺",
      "Do not work for corporations. Old corporations were meaningful when their founders were alive, Do not work for corporations. Old corporations were meaningful when their founders were alive, Do not work for corporations. Old corporations were meaningful when their founders were alive, Do not work for corporations. Old corporations were meaningful when their founders were alive,",
      "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
      null
    ]
  };

  final Map<Type, dynamic> _defaultValues = {
    bool: false,
    int: 0,
    double: 0.0,
    String: "",
    List: [],
    Map: {},
    Set: Set()
  };

  final Map<Type, List<GeneratedParam>> _generatorParams = {};
  final Map<Type, Function(MockGenerator)> _generators = {};

  void addValues<T>(List<T> values) {
    _valuesSet[T] = values;
  }

  void addGenerator<T>(T Function(MockGenerator) mockGenerator) {
    List<GeneratedParam> rules = [];
    final defaultValue = mockGenerator.call(MockGenerator._(
        valueProvider: _MapValueProvider(_defaultValues),
        onParam: (rule) {
          rules.add(rule);
        }));

    _defaultValues[T] = defaultValue;
    _generatorParams[T] = rules;
    _generators[T] = mockGenerator;
  }

  List<dynamic> listValues(Type type) {
    if (_valuesSet.containsKey(type)) {
      return _valuesSet[type]!;
    } else if (_generators.containsKey(type)) {
      final paramValuesRanges = getValuesRange(type);

      final random = Random();
      final result = [];

      for (var paramIndex = 0;
          paramIndex < paramValuesRanges.length;
          paramIndex++) {
        for (final targetValue in paramValuesRanges[paramIndex]) {
          final testingValuesSet = paramValuesRanges
              .map((value) => value[random.nextInt(value.length - 1)])
              .toList()
            ..[paramIndex] = targetValue;
          result.add(_generators[type]!.call(MockGenerator._(
              valueProvider: _ListValueProvider(testingValuesSet))));
        }
      }
      _valuesSet[type] = List.from(result)..add(null);
      return result;
    } else {
      throw "Can't find values for type: $type";
    }
  }

  List<dynamic> getValuesRange(Type type) {
    final result = [];
    for (GeneratedParam param in _generatorParams[type]!) {
      final itemValuesRanges;
      if (param.rule == null) {
        itemValuesRanges = listValues(param.forType);
      } else {
        itemValuesRanges =
            listValues(param.forType).where(param.rule!).toList();
      }
      if (param.collectionType == null) {
        result.add(itemValuesRanges);
      } else if (param.collectionType == Collection.List) {
        result.add([
          [],
          [itemValuesRanges[0]],
          itemValuesRanges
        ]);
      } else if (param.collectionType == Collection.Set) {
        result.add([
          Set(),
          Set()..add(itemValuesRanges[0]),
          Set.from(itemValuesRanges)
        ]);
      } else if (param.collectionType == Collection.Map) {
        result.add([{}]);
      }
    }
    return result;
  }
}
