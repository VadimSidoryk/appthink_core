import 'package:applithium_core/usecases/base.dart';
import 'package:rxdart/transformers.dart';

class QueueUseCase<D> extends UseCase<D> {
  final List<UseCase<D>> useCases;

  QueueUseCase(this.useCases);

  @override
  Stream<D> invokeImpl({D? state}) {
    Stream<D> result = useCases[0].invokeImpl(state: state);
    if (useCases.length == 1) {
      return result;
    }
    for (int i = 1; i < useCases.length; i++) {
      result = result.flatMap((event) => useCases[i].invokeImpl(state: event));
    }

    return result;
  }
}
