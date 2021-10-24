import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';

abstract class AplService {

  AplService();

  Future<void> init(AplConfig appConfig);

  void addToStore(Store store) {
    store.add((provider) => this);
  }
}