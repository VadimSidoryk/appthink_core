import 'package:flutter/cupertino.dart';

import 'scope.dart';

enum _StoreFactoryType { factory, single }

abstract class InstanceProvider {
  T get<T>({String? key});

  T? getOrNull<T>({String? key});
}

///Simple instance store
class Store extends InstanceProvider {
  Map<Type, Map<String, _StoreFactory<dynamic>>> _map = const {};

  Store();

  Store.extend(BuildContext parentsSource) {
    final parentScope = Scope.of(parentsSource);
    final Map<Type, Map<String, _StoreFactory<dynamic>>> resultMap = Map.from(parentScope.store._map);
    _map.keys.forEach((key) {
      if(resultMap.containsKey(key)) {
        resultMap[key]!.addAll(_map[key]!);
      } else {
        resultMap[key] = _map[key]!;
      }
    });
    _map = resultMap;
  }

  @override
  T get<T>({String? key}) {
    final keysMap = _map[T];
    // ignore: unnecessary_null_comparison
    if (keysMap == null) {
      throw new Exception("${T.toString()} is not mapped in store.");
    }
    final storeFactory = keysMap[key ?? ""];
    if(storeFactory == null) {
      throw new Exception("${T.toString()} with key $key is not mapped in store.");
    }

    return storeFactory.instance;
  }

  @override
  T? getOrNull<T>({String? key}) {
    if (_map.containsKey(T)) {
      return get<T>(key: key);
    } else {
      return null;
    }
  }

  call<T>({String? key}) => get<T>(key: key);

  ///registers transient instances ( a new instance is provider per request )
  addFactory<T>(T Function(InstanceProvider) func, {String? key}) {
    _addStoreFactory(_StoreFactoryType.factory, func , key ?? "");
  }

  ///registers lazy instances ( they get instantiated on first request )
  add<T>(T Function(InstanceProvider) func, {String? key}) {
    _addStoreFactory(_StoreFactoryType.single, func , key ?? "");
  }

  _addStoreFactory<T>(_StoreFactoryType type, T Function(InstanceProvider) func, String key) {
    final map = _map[T];
    if (map == null) {
      _map[T] = {
        key : _StoreFactory<T>(_StoreFactoryType.factory,
            func: () => func.call(this))
      };
    } else {
      _map[T] = map
        ..[key] = _StoreFactory<T>(_StoreFactoryType.factory,
            func: () => func.call(this));
    }
  }

  clear() {
    _map.clear();
  }
}

///StoreFactory
///a little functor to help provide the right instance
class _StoreFactory<T> {
  _StoreFactoryType type;
  final T Function() _func;
  T? _instance;

  _StoreFactory(this.type, {func, instance})
      : _func = func,
        _instance = instance;

  T get instance {
    try {
      switch (type) {
        case _StoreFactoryType.single:
          if (_instance == null) {
            _instance = _func();
          }
          return _instance as T;
        case _StoreFactoryType.factory:
          return _func();
      }
    } catch (e, s) {
      print("Error while creating ${T.toString()}");
      print('Stack trace:\n $s');
      rethrow;
    }
  }
}
