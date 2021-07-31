import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:core_firebase/messaging.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirebaseModule extends AplModule {
  @override
  addTo(Store store) {
    store.add((provider) => FirebaseMessagingService());
  }

  @override
  void init(BuildContext context, ApplicationConfig config) {
    // TODO: implement init
  }
}