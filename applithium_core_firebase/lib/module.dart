import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core_firebase/analytics.dart';
import 'package:applithium_core_firebase/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:applithium_core/services/messaging/service.dart';

import 'messaging.dart';

class FirebaseModule extends AplModule {

  @override
  void injectInGlobalLevel(Store store) {
    store.add<ConfigProvider>((provider) => FirebaseConfigProvider(
      fetchTimeoutSec: 2
    ));
  }

  @override
  void injectInAppLevel(Store store) async {
    await Firebase.initializeApp();
    final ApplicationConfig config = store.get();
    store.add<MessagingService>((provider) => FirebaseMessagingService(
        router: provider.get(), appKey: config.messagingApiKey));
    store.get<AnalyticsService>().addAnalyst(FirebaseAnalyst());
  }
}
