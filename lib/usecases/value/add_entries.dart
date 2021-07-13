import 'package:applithium_core/usecases/base.dart';

class ValueAddEntriesUseCase extends UseCase<Map<String, dynamic>> {
  @override
  Stream<Map<String, dynamic>> invokeImpl(Map<String, dynamic>? state, Map<String, dynamic> params) async* {
    yield (state ?? Map())..addAll(params);
  }
}