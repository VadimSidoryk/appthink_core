import 'abs.dart';

class AplLogger extends Logger {

  static AplLogger? _instance;

  static AplLogger get instance {
    if(_instance != null) {
      return _instance!;
    } else {
      throw "You should call AplLogger.initWith at first";
    }
  }

  static void initWith(List<Logger> impls) {
    _instance = AplLogger._(impls);
  }

  final List<Logger> _impls;

  AplLogger._(this._impls);

  @override
  void e(String tag, String message, [ex, StackTrace? stacktrace]) {
    for(Logger impl in _impls) {
      try {
        impl.e(tag, message, ex, stacktrace);
      } catch(_) { /* ignore this impl */}
    }
  }

  @override
  void log(String tag, String message, {LogLevel level = LogLevel.debug}) {
    for(Logger impl in _impls) {
      try {
        impl.log(tag, message, level: level);
      } catch(_) { /* ignore this impl */}
    }
  }}