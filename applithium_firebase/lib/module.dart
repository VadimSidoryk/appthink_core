import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/module.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/utils/extension.dart';

import 'analyst.dart';
import 'config.dart';
import 'log_tree.dart';

const _KEY_MODE = "mode";
const _MODE_RELEASE = "release";
const _MODE_DEBUG = "debug";

class FirebaseModule extends AplModule {
  bool useAnalytics;
  FirebaseApp? _app;
  FirebaseAnalytics? _analytics;
  FirebaseConfigProvider? provider;

  FirebaseModule({this.provider, this.useAnalytics = true});

  @override
  Future<bool> injectConfigProvider(Store store) async {
    logMethod("injectConfigProvider");
    _app = await Firebase.initializeApp();
    store.add((provider) => _app);

    _analytics = useAnalytics ? FirebaseAnalytics.instance : null;
    _analytics?.setUserProperty(
        name: _KEY_MODE, value: kReleaseMode ? _MODE_RELEASE : _MODE_DEBUG);
    provider?.let(
            (notNullVal) => store.add<ConfigProvider>((provider) => notNullVal));
    return true;
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    logMethod("injectDependencies");
    final crashlytics = FirebaseCrashlytics.instance;
    crashlytics.setCustomKey(
        _KEY_MODE, kReleaseMode ? _MODE_RELEASE : _MODE_DEBUG);
    FlutterError.onError = crashlytics.recordFlutterError;
    store.add<LogTree>((provider) => CrashlyticsTreeImpl());
    _analytics?.let((val) {
      store.get<AnalyticsService>().addAnalyst(FirebaseAnalyst(val));
    });
  }
}
