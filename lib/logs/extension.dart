extension Loggable on Object {
     void log(String message) {
        print("$this/Logs  : $message");
     }

     void logMethod(String methodName, {Object? source, List<Object?> params = const []}) {
        log("${source ?? this } : $methodName with params $params");
     }

     void logError(dynamic exception) {
          print("$this/Error : $exception ");
     }

     Object logResult(Object source, String methodName) {
          source.log("$methodName returns $this");
          return this;
     }
}