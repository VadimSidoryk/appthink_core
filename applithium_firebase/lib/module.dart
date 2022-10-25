import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/module.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/utils/extension.dart';
import 'package:rxdart/subjects.dart';
import 'package:applithium_core/app_state_base.dart';

import 'analyst.dart';
import 'config.dart';
import 'log_tree.dart';

const _KEY_MODE = "mode";
const _MODE_RELEASE = "release";
const _MODE_DEBUG = "debug";

const KEY_DATABASE_CONNECTED = "connected_to_database";

class FirebaseModule extends AplModule {
  bool useAnalytics;
  bool useDatabase;
  bool offlineModeEnabled;
  late FirebaseApp _app;
  FirebaseAnalytics? _analytics;
  FirebaseConfigProvider? provider;

  FirebaseModule({this.provider, this.useAnalytics = true, this.offlineModeEnabled = false, this.useDatabase = false});

  @override
  Future<bool> injectConfigProvider(Store store) async {
    logMethod("injectConfigProvider");
    _app = await Firebase.initializeApp();
    store.add((provider) => _app);

    await _setupAnalytics(store);

    provider?.let(
            (notNullVal) => store.add<ConfigProvider>((provider) => notNullVal));

    await _setupInitialMessage(store);

    return true;
  }

  _setupAnalytics(Store store) async {
    _analytics = useAnalytics ? FirebaseAnalytics.instance : null;
    await  _analytics?.setUserProperty(
        name: _KEY_MODE, value: kReleaseMode ? _MODE_RELEASE : _MODE_DEBUG);
  }

  _setupInitialMessage(Store store) async {
    final initialFirebaseMessage = await FirebaseMessaging.instance.getInitialMessage();
    log("initial firebaseX message =  $initialFirebaseMessage");
    final String? initialFirebaseLink = initialFirebaseMessage?.data["url"];
    log("initial firebase link = $initialFirebaseLink");
    store.add<String?>((p0) => initialFirebaseLink, key: KEY_EXTERNAL_INITIAL_LINK);
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    logMethod("injectDependencies");

    if(useDatabase) {
      _setupDatabase(store);
    }
    _setupCrashlytics(store);
  }

  void _setupDatabase(Store store) {
    if(offlineModeEnabled) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }

    final connectedSubj = BehaviorSubject.seeded(false);
    store.add<Stream<bool>>((p0) => connectedSubj, key: KEY_DATABASE_CONNECTED);

    final database = FirebaseDatabase.instanceFor(app: _app!);

    final connectedRef = database.ref(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      log("connected to firebase database = $connected");
      connectedSubj.add(connected);
    });

    store.add<FirebaseDatabase>((p0) => database);
  }

  void _setupCrashlytics(Store store) {
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
