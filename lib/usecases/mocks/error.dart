import 'package:applithium_core/usecases/base.dart';

UseCaseWithParams<void, dynamic, dynamic> error({int delayMillis = 0}) {
  return (data, params) async {
    if(delayMillis != 0) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
    throw "Mocked Error";
  };
}
