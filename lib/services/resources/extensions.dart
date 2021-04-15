import 'package:applithium_core/services/resources/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:applithium_core/scopes/extensions.dart';

extension ResourceSource on BuildContext {
  String getString(String key) {
    return this.get<ResourceService>().getString(key);
  }
}