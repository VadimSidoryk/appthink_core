abstract class Logger {

  const Logger();

  void log(String tag, String message, {LogLevel level = LogLevel.debug});

  void e(String tag, String message, [dynamic ex, StackTrace? stacktrace]);

  StackTrace removeLast(StackTrace trace, int count) {
    final stackTraceParts = trace.toString().split(RegExp("#d"));
    final sb = StringBuffer();
    for(int i = count; i < stackTraceParts.length; i++) {
      sb.write(stackTraceParts[i]);
    }

    return StackTrace.fromString(sb.toString());
  }
}

enum LogLevel {
  debug,
  verbose,
  warning
}