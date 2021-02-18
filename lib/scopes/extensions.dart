import 'package:flutter/widgets.dart';
import 'scope.dart';

extension ScopedContext on BuildContext {
  T get<T>() {
    return Scope.get<T>(this);
  }
}
