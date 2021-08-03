import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:flutter/widgets.dart';

abstract class AplModule<T> {
  void injectInGlobalLevel(Store store);

  void injectInAppLevel(Store store);
}
