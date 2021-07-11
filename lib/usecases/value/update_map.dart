import 'package:applithium_core/usecases/base.dart';

class ValueUpdateUseCase extends UseCase<Map<String, dynamic>> {

  final String stateKey;
  final String paramKey;

  ValueUpdateUseCase(this.stateKey, this.paramKey);

  @override
  Stream<Map<String, dynamic>> invokeImpl(Map<String, dynamic>? state,
      Map<String, dynamic> params) async* {
    state as Map<String, dynamic>;
    yield state..[stateKey] = params[paramKey];
  }
}