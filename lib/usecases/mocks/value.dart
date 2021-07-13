import 'package:applithium_core/usecases/base.dart';

class MockValueUseCase<T> extends UseCase<T> {
  final int delayMillis;
  final T value;

  MockValueUseCase(this.value, { this.delayMillis = 0});

  @override
  Stream<T> invokeImpl(T? state, Map<String, dynamic> params) async* {
    if(delayMillis != 0) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
    yield value;
  }
}
