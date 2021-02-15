
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/base_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ContentRepository<T> extends BaseRepository<T> {

  State _state = State.INITIAL;

  @protected
  final Logger logger;

  Future<bool> isOutdated;

  @protected
  final data = BehaviorSubject<T>();
  @override
  Stream<T> get dataStream => data.stream;

  ContentRepository(this.logger);

  Future<T> loadData();

  @override
  Future<bool> updateData(bool isForced) async {
     final needToUpdate = await checkNeedToUpdate(isForced);
     if(needToUpdate) {
       _state = State.UPDATING;
       return loadData().then((value) {
         onNewData(value);
         _state = State.UPDATED;
         return true;
       }, onError: () {
         logger.error(Exception("Can't update data"));
         _state = State.UPDATED;
         return false;
       });
     } else {
       return false;
     }
  }

  @override
  void close() {
    data.close();
  }

  @protected
  void onNewData(T value) {
    data.sink.add(value);
  }
  
  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != State.UPDATING  && (isForced || await isOutdated);
  }
}

enum State {
  INITIAL,
  UPDATING,
  UPDATED
}