import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


class CrashlyticsTree extends LogTree {

  static const errorLevel = "E";

  @override
  List<String> getLevels() {
    return [errorLevel];
  }

  @override
  void log(String level, String message, {String? tag, ex, StackTrace? stacktrace}) {
    if(level == errorLevel) {
      FirebaseCrashlytics.instance.recordError(ex, stacktrace);
    }
  }
}