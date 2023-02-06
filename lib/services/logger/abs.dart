import 'package:flutter/foundation.dart';

abstract class Logger {

  const Logger();

  void log(String tag, String message, {LogLevel level = LogLevel.debug});

  void e(String tag, String message, [dynamic ex, StackTrace? stacktrace]);

  @protected
  static StackTrace removeLogs(StackTrace original, int count) {
    final stackTraceParts = original.toString().split(RegExp(r'#[0-9]+'));
    final sb = StringBuffer();
    for(int i = count + 1; i < stackTraceParts.length; i++) {
      sb.write("#${i - (count + 1)}     ${stackTraceParts[i]}");
    }

    return StackTrace.fromString(sb.toString());
  }
}

enum LogLevel {
  debug,
  verbose,
  warning
}