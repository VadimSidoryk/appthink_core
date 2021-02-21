import 'package:applithium_core/logs/default_logger.dart';
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
  Stream<T> get updatesStream => data.stream;

  ContentRepository({this.logger = const DefaultLogger("ContentRepository")});

  Future<T> loadData();

  @override
  Future<bool> updateData(bool isForced) async {
    final needToUpdate = await checkNeedToUpdate(isForced);
    if (needToUpdate) {
      _state = State.UPDATING;
      return loadData().then((value) {
        onNewData(value);
        _state = State.UPDATED;
        return true;
      }, onError: (ebj, exception) {
        logger.error(exception);
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
  updateLocalData(T func(T)) {
    if (data.hasValue) {
      data.sink.add(func(data.value));
    }
  }

  @protected
  Future<bool> checkNeedToUpdate(bool isForced) async {
    return _state != State.UPDATING && (isForced || await isOutdated);
  }
}

enum State { INITIAL, UPDATING, UPDATED }
