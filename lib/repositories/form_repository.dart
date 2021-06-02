import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:flutter/foundation.dart';

abstract class FormRepository<T> extends ContentRepository<T> {

  @override
  Stream<T> get updatesStream => data.stream.first.asStream();

  Future<T?> applyForm() async {
    state = ContentRepositoryState.UPDATING;
    try {
      if(!data.hasValue) {
        throw Exception("Illegal State exception");
      }
      final value = await data.first;
      await applyFormImpl(value);
      return value;
    } catch(e) {
      logError(e);
      return null;
    }
  }

  @protected
  Future<bool> applyFormImpl(T value);
}
