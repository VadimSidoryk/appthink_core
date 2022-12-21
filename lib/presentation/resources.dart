import 'package:applithium_core/utils/extension.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

typedef Loader = Function(String);

abstract class LoadableType {
  Loader get loader;
}

class WidgetResources {
  final BuildContext context;
  final assetsMap = <String, LoadableType>{};

  WidgetResources(this.context);

  @protected
  String loadable(String path, LoadableType type) {
    assetsMap[path] = type;
    return path;
  }

  @protected
  Future<Result<void>> preload() => safeCall(() {
    assetsMap.entries.forEach((element) {
      final loader = element.value.loader;
      loader.call(element.key);
    });
  });
}
