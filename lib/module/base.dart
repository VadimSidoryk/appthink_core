import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';

abstract class AplModule {
  Future<bool> injectConfigProvider(Store store);

  Future<void> injectDependencies(Store store, AplConfig config);
}
