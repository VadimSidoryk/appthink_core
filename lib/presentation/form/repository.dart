import 'dart:async';

import 'package:applithium_core/presentation/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';

enum FormRepositoryState {
  INITIAL,
  PRESET_LOADING,
  PRESENT_SHOWN,
  FORM_SENDING,
  FORM_SENT
}

class FormRepository<T> extends BaseRepository<T> {
  @protected
  FormRepositoryState state = FormRepositoryState.INITIAL;

  final UseCase<T>? load;
  final UseCase<T> send;

  FormRepository(
      {this.load, required this.send, int ttl = 60 * 1000})
      : super(ttl);

  Future<bool> loadData({required bool isForced}) async {
    final needToUpdate = state != FormRepositoryState.PRESET_LOADING &&
        (isForced || isOutdated);

    if (needToUpdate && load != null) {
      final result = await apply(load!);
      if (result) {
        markAsUpdated();
      }
      return result;
    } else {
      state = FormRepositoryState.PRESENT_SHOWN;
      return false;
    }
  }

  Future<bool> sendForm() async {
    final readyToSendForm = state == FormRepositoryState.PRESENT_SHOWN;

    if (readyToSendForm) {
      state = FormRepositoryState.FORM_SENDING;
      final result = await apply(send);
      if (result) {
        state = FormRepositoryState.FORM_SENT;
      } else {
        state = FormRepositoryState.PRESENT_SHOWN;
      }

      return result;
    } else {
      return false;
    }
  }

  @override
  void markAsUpdated() {
    state = FormRepositoryState.PRESENT_SHOWN;
    super.markAsUpdated();
  }
}
