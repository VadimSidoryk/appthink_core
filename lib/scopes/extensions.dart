import 'package:flutter/widgets.dart';

import 'scope.dart';

extension ScopedContext on BuildContext {
  T get<T>({String key = ""}) {
    return Scope.get<T>(this, key);
  }

  T? getOrNull<T>({String key = ""}) {
    return Scope.getOrNull<T>(this, key);
  }
}
