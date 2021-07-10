import 'dart:async';

import 'package:applithium_core/repositories/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';

enum ContentRepositoryState { INITIAL, UPDATING, UPDATED }

class ContentRepository extends BaseRepository<Map<String, dynamic>> {

  @protected
  ContentRepositoryState state = ContentRepositoryState.INITIAL;

  bool _isOutdated = true;
  StreamSubscription? _subscription;
  final int timeToLiveMillis;
  final UseCase<Map<String, dynamic>> load;

  ContentRepository({required this.load, this.timeToLiveMillis = 60 * 1000});

  Future<bool> loadData(bool isCalledByUser) async {
    final needToUpdate = await checkNeedToUpdate(isCalledByUser);
    if (needToUpdate) {
      final result = await apply(load);
      if(result) {
        markAsUpdated();
      }
      return result;
    } else {
      return false;
    }
  }

  @protected
  void markAsOutdated() {
    if(_subscription != null) {
      _subscription?.cancel();
      _subscription = null;
    }
    
    _isOutdated = true;
  }

  @protected
  void markAsUpdated() {
    state = ContentRepositoryState.UPDATED;

    if(_subscription != null) {
      _subscription?.cancel();
      _subscription = null;
    }

    _isOutdated = false;
    
   _subscription = Future.delayed(Duration(milliseconds: timeToLiveMillis), () { return true; })
        .asStream()
        .listen((value) {
          _isOutdated = value;
          _subscription = null;
    });
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return state != ContentRepositoryState.UPDATING && (isForced || _isOutdated);
  }
}

