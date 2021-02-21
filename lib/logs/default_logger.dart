import 'logger.dart';

class DefaultLogger extends Logger {

  final String _tag;

  const DefaultLogger(this._tag);

  @override
  void error(Exception exception) {
    print("$_tag : Exception : $exception");
  }

  @override
  void log(String message) {
    print("$_tag : $message");
  }
}