import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:core_firebase/messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:applithium_core/services/messaging/service.dart';
import 'package:flutter/widgets.dart';

class FirebaseModule extends AplModule {
  @override
  addTo(Store store) {
    store.add<MessagingService>((provider) => FirebaseMessagingService(provider.get()));
  }

  @override
  void init(BuildContext context, ApplicationConfig config) async {
    await Firebase.initializeApp();
  }

  @override
  injectInTree(Store store) {
    // TODO: implement injectInTree
    throw UnimplementedError();
  }
}