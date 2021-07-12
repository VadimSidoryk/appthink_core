import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:flutter/widgets.dart';

abstract class AplModule<T> {

  T addTo(Store store);

  void init(BuildContext context, ApplicationConfig config);
}
