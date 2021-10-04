import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/messaging/service.dart';
import 'package:applithium_core_firebase/analytics.dart';
import 'package:applithium_core_firebase/config.dart';
import 'package:applithium_core_firebase/crashlytics_tree.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'messaging.dart';

class FirebaseModule extends AplModule {

  @override
  void injectToGlobal(Store store) async {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    store.add<ConfigProvider>((provider) => FirebaseConfigProvider(
      fetchTimeoutSec: 2
    ));
    store.add<LogTree>((provider) => CrashlyticsTree());
  }

  @override
  void injectToApp(Store store) async {
    final AplConfig config = store.get();
    store.add<MessagingService>((provider) => FirebaseMessagingService(
        router: provider.get(), appKey: config.messagingApiKey));
    store.get<AnalyticsService>().addAnalyst(FirebaseAnalyst());
  }
}
