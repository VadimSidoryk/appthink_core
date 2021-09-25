import 'dart:async';

import 'package:applithium_core/either/either.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AplRepository<T> {
  @protected
  final data = BehaviorSubject<T>();

  Stream<T> get updatesStream => data.stream;

  CancelableOperation? _cancelableOperation;
  @protected
  final int timeToLiveMillis;
  @protected
  bool isOutdated = true;

  AplRepository(this.timeToLiveMillis);

  Future<Either<bool>> _loadWith(UseCase<void, T> useCase) async {
    final completer = Completer<Either<bool>>();

    await _cancelableOperation?.cancel();
    _cancelableOperation =
        CancelableOperation.fromFuture(useCase.call(null)).then((data) {
      onNewData(data);
      completer.complete(Either.withValue(true));
    }, onError: (error, stacktrace) {
          logError("applyInitial cause error", ex: error);
          completer.complete(Either.withError(error));
    }, onCancel: () {
      completer.complete(Either.withValue(false));
    });

    return completer.future.whenComplete(() => _cancelableOperation = null);
  }
  Future<Either<bool>> _loadIfOutdatedWith(UseCase<void, T> useCase) {
    if(isOutdated) {
      return _loadWith(useCase);
    } else {
      return Future.value(Either.withValue(false));
    }
  }

  Future<Either<bool>> _changeWith(UseCase<T, T> operation,
      {resetOperationsStack = false}) async {
    final completer = Completer<Either<bool>>();

    if (resetOperationsStack || _cancelableOperation == null) {
      await _cancelableOperation?.cancel();
      final dataValue = data.value!;
      _cancelableOperation =
          CancelableOperation.fromFuture(operation.call(dataValue)).then(
              (data) {
        onNewData(data);
        completer.complete(Either.withValue(true));
      }, onError: (error, stacktrace) {
        logError("apply cause error", ex: error);
        completer.complete(Either.withError(error));
      }, onCancel: () {
        completer.complete(Either.withValue(false));
      });
    } else {
      _cancelableOperation = _cancelableOperation!.then((data) {
        CancelableOperation.fromFuture(operation.call(data)).then((data) {
          onNewData(data);
          completer.complete(Either.withValue(true));
        }, onError: (error, stacktrace) {
          logError("apply cause error", ex: error);
          completer.complete(Either.withError(error));
        }, onCancel: () {
          completer.complete(Either.withValue(false));
        });
      });
    }
    return completer.future.whenComplete(() => _cancelableOperation = null);
  }

  @protected
  Future<bool> cancelCurrentOperation() async {
    if (_cancelableOperation == null) {
      return false;
    }
    await _cancelableOperation!.cancel();
    _cancelableOperation = null;
    return true;
  }

  @protected
  void onNewData(T value) async {
    data.sink.add(value);
  }

  void close() {
    data.close();
  }
}

abstract class SideEffect<M>  {
  Future<Either<bool>> apply(AplRepository<M> repo);

  factory SideEffect.init(UseCase<void, M> sourceUseCase) =>
      Init<M>._(sourceUseCase);

  factory SideEffect.change(UseCase<M, M> changingUseCase) =>
      Change<M>._(changingUseCase);

  factory SideEffect.post(UseCase<M, bool> sendingUseCase) =>
      Post<M>._(sendingUseCase);

  SideEffect._();

}

class Init<M> extends SideEffect<M> {
  final UseCase<void, M> sourceUseCase;

  Init._(this.sourceUseCase): super._();

  @override
  Future<Either<bool>> apply(AplRepository<M> repo) {
    return repo._loadWith(sourceUseCase);
  }
}

class Change<M> extends SideEffect<M> {
  final UseCase<M, M> changingUseCase;

  Change._(this.changingUseCase): super._();

  @override
  Future<Either<bool>> apply(AplRepository<M> repo) {
    return repo._changeWith(changingUseCase);
  }
}

class Post<M> extends SideEffect<M> {
  final UseCase<M, bool> sendingUseCase;

  Post._(this.sendingUseCase): super._();

  @override
  Future<Either<bool>> apply(AplRepository<M> repo) async {
    final data = await repo.updatesStream.first;
    if (data == null) {
      return Either.withError("Can't get value from repository");
    } else {
      try {
        final result = await sendingUseCase.call(data);
        return Either.withValue(result);
      } catch (e) {
        return Either.withError(e);
      }
    }
  }
}
