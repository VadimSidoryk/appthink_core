import 'either.dart';
import 'package:applithium_core/logs/extension.dart';

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

extension FunctionExt<T> on T Function() {
  Either<T> safeCall(Object holder, String methodName, [List<Object> params = const []]) {
    try {
      holder.logMethod(methodName, params: params);
      return Either.withValue(this.call())..logResult(holder, methodName);
    } catch (e, stacktrace) {
      holder.logError(methodName, ex: e, stacktrace: stacktrace);
      return Either.withError(e);
    }
  }
}

extension FutureFunctionExt<T> on Future<T> Function() {
  Future<Either<T>> safeCall(Object holder, String methodName, [List<Object> params = const []]) async {
    try {
      holder.logMethod(methodName, params: params);
      return Either.withValue(await this.call())..logResult(holder, methodName);
    } catch (e, stacktrace) {
      holder.logError(methodName, ex: e, stacktrace: stacktrace);
      return Either.withError(e);
    }
  }
}
