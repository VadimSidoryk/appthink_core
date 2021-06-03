import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:flutter/widgets.dart';

abstract class Module<T> {

  T create(InstanceProvider dependencyProvider);

  void init(BuildContext context, AplConfig config);
}
