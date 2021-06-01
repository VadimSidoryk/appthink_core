import 'package:applithium_core_example/page/domain.dart';

class MyUseCaseImpl extends MyUseCase {
  @override
  Future<int> increment(int currentValue) async {
    return currentValue + 1;
  }

  @override
  Future<int> loadInitialValue() async {
    return 0;
  }
}