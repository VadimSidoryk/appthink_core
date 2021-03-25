extension Loggable on Object {
     void log(String message) {
        print("$this/Logs  : $message");
     }

     void logError(dynamic exception) {
          print("$this/Error : $exception ");
     }
}