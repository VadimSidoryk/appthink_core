import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/base.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';

abstract class Module<T extends AplService> {

  final Set<Submodule<T>> submodules;

  Module({this.submodules = const {}});

  T create(InstanceProvider dependencyProvider);

  void init(BuildContext context, AplConfig config) {
    final value = context.get<T>();
    value.init(context, config);
    submodules.forEach((submodule) => submodule.extend(value, config));
  }
}

abstract class Submodule<T> {
    void extend(T value, AplConfig config);
}