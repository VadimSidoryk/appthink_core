import 'package:applithium_core/usecases/base.dart';

class MockErrorUseCase<T> extends UseCase<T> {

  final int delayMillis;

  MockErrorUseCase({this.delayMillis = 0});

  @override
  Stream<T> invokeImpl(T? state, Map<String, dynamic> params) async* {
    if(delayMillis != 0) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
    throw "Mocked Error";
  }

}