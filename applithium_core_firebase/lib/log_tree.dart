import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

const _ERROR_LEVEL = "E";

class CrashlyticsTreeImpl extends LogTree {

  @override
  List<String> getLevels() {
    return [_ERROR_LEVEL];
  }

  @override
  void log(String level, String message, {String? tag, ex, StackTrace? stacktrace}) {
    if(level == _ERROR_LEVEL) {
      FirebaseCrashlytics.instance.recordError(ex, stacktrace);
    }
  }
}