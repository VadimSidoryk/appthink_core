



import 'package:applithium_core/services/logger/service.dart';

import '../services/logger/abs.dart';

extension Loggable on Object {
  void log(String message, {LogLevel level = LogLevel.debug}) {
    AplLogger.instance.log(this.runtimeType.toString(), message, level: level);
  }

  void logError(String message, [dynamic ex, StackTrace? stacktrace]) {
    AplLogger.instance.e(this.runtimeType.toString(), message, ex, stacktrace);
  }

  void logMethodResult(String methodName, List<dynamic> params, dynamic result) {
    log("$methodName(${params.join(",")}) -> $result");
  }
}
