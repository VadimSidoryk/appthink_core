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

  void logError(String message, [dynamic ex, StackTrace? stacktrace]) {
    Fimber.withTag(this.runtimeType.toString(), (log) {
      log.e(message, ex: ex, stacktrace: stacktrace);
    });
  }

  void logMethodResult(String methodName, List<dynamic> params, dynamic result) {
    log("$methodName(${params.join(",")}) -> $result");
  }
}
