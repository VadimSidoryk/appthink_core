import 'package:applithium_core/usecases/base.dart';

UseCaseWithParams<dynamic, T, dynamic> value<T>({required T value, int delayMillis = 0}) {
  return (_, params) async {
    if(delayMillis != 0) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
    return value;
  };
}

