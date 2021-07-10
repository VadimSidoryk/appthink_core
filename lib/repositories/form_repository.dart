import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/repositories/value_repository.dart';
import 'package:flutter/foundation.dart';

enum FormRepositoryState { INITIAL, UPDATING, UPDATED, FORM_APPLYING, FORM_APPLIED }

class FormRepository extends ContentRepository {
  FormRepository() : super();


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
