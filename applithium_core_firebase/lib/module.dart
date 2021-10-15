import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/messaging/service.dart';
import 'package:applithium_core_firebase/config.dart';
import 'package:applithium_core_firebase/crashlytics_tree.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:applithium_core/utils/any.dart';

import 'analytics.dart';
import 'messaging.dart';

const _KEY_MODE = "mode";
const _MODE_RELEASE = "release";
const _MODE_DEBUG = "debug";

class FirebaseModule extends AplModule {
  FirebaseAnalytics? _analytics;

  @override
  Future<void> injectOnSplash(Store store) async {
    await Firebase.initializeApp();
    final crashlytics = FirebaseCrashlytics.instance;
    crashlytics.setCustomKey(
        _KEY_MODE, kReleaseMode ? _MODE_RELEASE : _MODE_DEBUG);
    FlutterError.onError = crashlytics.recordFlutterError;
    _analytics = FirebaseAnalytics()
      ..setUserProperty(
          name: _KEY_MODE, value: kReleaseMode ? _MODE_RELEASE : _MODE_DEBUG);
    store.add<ConfigProvider>(
        (provider) => FirebaseConfigProvider(fetchTimeoutSec: 2));
    store.add<LogTree>((provider) => CrashlyticsTree());
  }

  @override
  void injectOnMain(Store store) {
    final AplConfig config = store.get();
    store.add<MessagingService>((provider) => FirebaseMessagingService(
        router: provider.get(), appKey: config.messagingApiKey));
    _analytics?.let((val) {
      store.get<AnalyticsService>().addAnalyst(FirebaseAnalyst(val));
    });
  }
}
