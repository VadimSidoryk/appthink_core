import 'package:fimber/fimber.dart';

extension Loggable on Object {
  void log(String message) {
    Fimber.withTag(this.runtimeType.toString(), (log) {
      log.d(message);
    });
  }

  void logMethod(String methodName,
      {Object? source, List<Object?> params = const []}) {
    (source ?? this).log(": $methodName ($params)");
  }

  void logError(String message, {dynamic ex, StackTrace? stacktrace}) {
    Fimber.withTag(this.runtimeType.toString(), (log) {
      log.e(message, ex: ex, stacktrace: stacktrace);
    });
  }

  Object logResult(Object source, String methodName) {
    source.log("$methodName -> $this");
    return this;
  }
}

T logAndRun<T>(Object holder, String functionName, List<dynamic> params, T Function() block) {
  final message = "$functionName($params)";
  holder.log("call $message");
  try {
    final result = block();
    holder.log("$message -> $result");
    return result;
  } catch(e) {
    holder.logError("$holder:$message throw $e");
    throw e;
  }
}

Future<T> logAndRunAsync<T>(Object holder, String functionName, List<dynamic> params, Future<T> Function() block) async {
  final message = "$functionName($params)";
  holder.log("call $message");
  try {
    final result = await block();
    holder.log("$message emit $result");
    return result;
  } catch(e) {
    holder.logError("$holder:$message throw $e");
    throw e;
  }
}

Stream<T> logAndRunStream<T>(Object holder, String functionName, List<dynamic> params, Stream<T> Function() block) {
  final message = "$functionName($params)";
  holder.log("call $message");
  try {
    return block().map((result) {
      holder.log("$message: emit $result");

      return result;
    });
  } catch(e) {
    holder.logError("$holder:$message throw $e");
    throw e;
  }
}
