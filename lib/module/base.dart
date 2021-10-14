import 'package:applithium_core/scopes/store.dart';

abstract class AplModule<T> {
  Future<void> injectOnSplash(Store store);

  void injectOnMain(Store store);
}
