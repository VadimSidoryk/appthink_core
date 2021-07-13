import 'package:applithium_core/usecases/base.dart';

class ValueUpdateEntriesUseCase extends UseCase<Map<String, dynamic>> {

  final Map<String, String> stateToParamMap;

  ValueUpdateEntriesUseCase(this.stateToParamMap);

  @override
  Stream<Map<String, dynamic>> invokeImpl(Map<String, dynamic>? state,
      Map<String, dynamic> params) async* {
    state as Map<String, dynamic>;
    stateToParamMap.entries.forEach((entry) {
      state..[entry.key] = params[entry.value];
    });
    yield state;
  }
}