import 'package:applithium_core/usecases/base.dart';

UseCase<void, T> value<T>({required T value, int delayMillis = 0}) {
  return (_) async {
    if(delayMillis != 0) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
    return value;
  };
}

