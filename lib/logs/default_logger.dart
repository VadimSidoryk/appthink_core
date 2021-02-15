import 'logger.dart';

class DefaultLogger extends Logger {

  const DefaultLogger();

  @override
  void error(Exception exception) {
    print("Exception : $exception");
  }

  @override
  void log(String message) {
    print(message);
  }
}