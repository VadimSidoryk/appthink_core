import 'package:applithium_core/usecases/base.dart';

class ParallelUseCase<D> extends UseCase<D> {
  final List<UseCase<D>> useCases;

  ParallelUseCase(this.useCases);

  @override
  Stream<D> invokeImpl({D? state}) async* {
    for(UseCase<D> useCase in useCases) {
      yield* useCase.invokeImpl(state: state);
    }
  }
}