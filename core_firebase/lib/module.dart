import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:core_firebase/messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:applithium_core/services/messaging/service.dart';

class FirebaseModule extends AplModule {
  @override
  void injectInTree(Store store) async {
    await Firebase.initializeApp();
    final ApplicationConfig config = store.get();
    store.add<MessagingService>((provider) => FirebaseMessagingService(
        router: provider.get(), appKey: config.messagingApiKey));
  }
}
