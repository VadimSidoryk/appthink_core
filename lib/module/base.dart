import 'package:applithium_core/scopes/store.dart';

abstract class AplModule<T> {
  void injectToGlobal(Store store);

  void injectToApp(Store store);
}
