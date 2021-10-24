import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';

import '../service_base.dart';

const _KEY_MESSAGING_API_KEY = "messaging_api_key";

abstract class MessagingService  extends AplService {

  late String? apiKey;

  Stream<String> get tokenStream;

  @override
  Future<void> init(AplConfig config) async {
    apiKey = config.getString(_KEY_MESSAGING_API_KEY).value;
  }

  @override
  void addToStore(Store store) {
    if(apiKey != null) {
      super.addToStore(store);
    }
  }

  void startListening();

  void stopListening();

}