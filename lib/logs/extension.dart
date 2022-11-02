import 'package:fimber/fimber.dart';

enum LogLevel {
  debug,
  verbose,
  warning
}


extension Loggable on Object {

  void log(String message, {LogLevel level = LogLevel.debug}) {
    Fimber.withTag(this.runtimeType.toString(), (log) {
      switch(level) {
        case LogLevel.debug:
          log.d(message);
          break;
        case LogLevel.verbose:
          log.v(message);
          break;
        case LogLevel.warning:
          log.w(message);
      }
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
