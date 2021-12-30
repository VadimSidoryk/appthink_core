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

  void logError(String message, [dynamic ex, StackTrace? stacktrace]) {
    Fimber.withTag(this.runtimeType.toString(), (log) {
      log.e(message, ex: ex, stacktrace: stacktrace);
    });
  }

  Object logResult(Object source, String methodName) {
    source.log("$methodName -> $this");
    return this;
  }
}
