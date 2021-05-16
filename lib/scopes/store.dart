import 'package:flutter/cupertino.dart';

import 'scope.dart';

enum _StoreFactoryType { factory, single }

abstract class InstanceProvider {
  T get<T>();
}

///Simple instance store
class Store extends InstanceProvider {
  final _map = new Map<Type, _StoreFactory<dynamic>>();

  Store();
  
  Store.extend(BuildContext parentsSource) {
    final parentScope = Scope.of(parentsSource);
    _map.addAll(parentScope.store._map);
  }
  
  @override
  T get<T>() {
    _StoreFactory<T> sf = _map[T] as _StoreFactory<T>;
    // ignore: unnecessary_null_comparison
    if (sf == null) {
      throw new Exception("${T.toString()} is not mapped in store.");
    }
    return sf.instance;
  }

  call<T>() => get<T>();

  ///registers transient instances ( a new instance is provider per request )
  addFactory<T>(T Function(InstanceProvider) func) {
    _map[T] = _StoreFactory<T>(_StoreFactoryType.factory, func: () => func.call(this));
  }

  ///registers lazy instances ( they get instantiated on first request )
  add<T>(T Function(InstanceProvider) func) {
    _map[T] = _StoreFactory<T>(_StoreFactoryType.single, func: () => func.call(this));
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
