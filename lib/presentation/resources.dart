import 'package:applithium_core/utils/extension.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

typedef Loader = Future<void> Function(String);

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
  Future<Result<List<void>>> preload() => safeCall(() {
    final futures = assetsMap.entries.map((element) {
      final loader = element.value.loader;
      return loader.call(element.key);
    });

    return Future.wait(futures);
  });
}
