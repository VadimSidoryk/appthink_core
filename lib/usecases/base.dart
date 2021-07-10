import 'package:flutter/foundation.dart';
import 'package:applithium_core/logs/extension.dart';

abstract class UseCase<D> {

  UseCase<D> withParams(Map<String, dynamic> params) {
    return _UseCaseDelegate(this, params);
  }

  @protected
  Stream<D> invokeImpl({Map<String, dynamic> dynamicParams = const {}, D? state});

  Stream<D> invoke({D? state}) async* {
    try {
      yield* invokeImpl(state: state);
    } catch(e) {
      logError(e);
    }
  }
}

class _UseCaseDelegate<D> extends UseCase<D> {
  final UseCase<D> source;
  final Map<String, dynamic> paramsToAdd;

  _UseCaseDelegate (this.source, this.paramsToAdd);

  @override
  Stream<D> invokeImpl({Map<String, dynamic> dynamicParams = const {}, D? state}) {
    return source.invokeImpl(dynamicParams: dynamicParams..addAll(paramsToAdd), state: state);
  }
}