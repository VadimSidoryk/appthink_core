abstract class Logger {
  void log(String tag, String message, {LogLevel level = LogLevel.debug});

  void e(String tag, String message, [dynamic ex, StackTrace? stacktrace]);
}

enum LogLevel {
  debug,
  verbose,
  warning
}