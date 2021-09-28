import 'package:applithium_core/usecases/base.dart';

UseCase<void, T> value<T>({required T value, int delayMillis = 0}) => (_) async {
    if(delayMillis != 0) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
    return value;
  };

UseCase<void, M> error<M>({int delayMillis = 0}) => (data) async {
  if (delayMillis != 0) {
    await Future.delayed(Duration(milliseconds: delayMillis));
  }
  throw "Mocked Error";
};

