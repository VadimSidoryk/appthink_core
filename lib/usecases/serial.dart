import 'package:applithium_core/usecases/base.dart';
import 'package:rxdart/transformers.dart';

class SerialUseCase<D> extends UseCase<D> {
  final List<UseCase<D>> useCases;

  SerialUseCase(this.useCases);

  @override
  Stream<D> invokeImpl(D? state, Map<String, dynamic> params) {
    Stream<D> result = useCases[0].invokeImpl(state, params);
    if (useCases.length == 1) {
      return result;
    }
    for (int i = 1; i < useCases.length; i++) {
      result = result
          .flatMap((event) => useCases[i].invokeImpl(state, params));
    }

    return result;
  }
}
