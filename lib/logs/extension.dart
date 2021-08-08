

import 'package:fimber/fimber.dart';

extension Loggable on Object {
     void log(String message) {
          Fimber.d(message);
     }

     void logMethod(String methodName, {Object? source, List<Object?> params = const []}) {
        log("${source ?? this } : $methodName with params $params");
     }

     void logError(String message, { dynamic ex}) {
          Fimber.e(message, ex: ex);
     }

     Object logResult(Object source, String methodName) {
          source.log("$methodName returns $this");
          return this;
     }
}