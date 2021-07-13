import 'dart:async';

import 'package:applithium_core/presentation/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';

enum ContentRepositoryState { INITIAL, UPDATING, UPDATED }

class ContentRepository<T> extends BaseRepository<T> {
  @protected
  ContentRepositoryState state = ContentRepositoryState.INITIAL;

  final UseCase<T> load;

  ContentRepository({required this.load, int ttl = 10 * 1000})
      : super(ttl);

  Future<bool> loadData({required bool isForced}) async {
    final needToUpdate = await checkNeedToUpdate(isForced);
    if (needToUpdate) {
      final result = await apply(load);
      if (result) {
        markAsUpdated();
      }
      return result;
    } else {
      return false;
    }
  }

  @override
  void markAsUpdated() {
    state = ContentRepositoryState.UPDATED;
    super.markAsUpdated();
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return state != ContentRepositoryState.UPDATING && (isForced || isOutdated);
  }
}
