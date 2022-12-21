import 'package:applithium_core/utils/extension.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

typedef Loader = Function(String);

abstract class LoadableType {
}

class WidgetResources {
  static final loadersMap = <LoadableType, Loader>{};

  static void setLoader(LoadableType key, Loader loader) {
    loadersMap[key] = loader;
  }


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
      final Loader? loader = loadersMap[element.value];
      loader?.call(element.key);
    });
  });

}
