import 'package:flutter/foundation.dart';
import 'package:applithium_core/logs/extension.dart';

abstract class UseCase<D> {
  UseCase<D> withEventParams(Map<String, dynamic> params) {
    return _UseCaseDelegate(this, params);
  }

  @protected
  Stream<D> invokeImpl(D? state, Map<String, dynamic> params);

  Stream<D> invoke(D? state) async* {
    try {
      yield* invokeImpl(state, {});
    } catch (e) {
      logError(e);
    }
  }
}

class _UseCaseDelegate<D> extends UseCase<D> {
  final UseCase<D> source;
  final Map<String, dynamic> paramsToAdd;

  _UseCaseDelegate(this.source, this.paramsToAdd);

  @override
  Stream<D> invokeImpl(D? state, Map<String, dynamic> params) {
    return source.invokeImpl(state, params..addAll(paramsToAdd));
  }
}
