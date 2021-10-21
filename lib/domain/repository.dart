import 'dart:async';

import 'package:applithium_core/utils/either.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'use_case.dart';

class AplRepository<T> {
  @protected
  final data = BehaviorSubject<T>();

  Stream<T> get updatesStream => data.stream;

  CancelableOperation? _cancelableOperation;

  @protected
  final int timeToLiveMillis;
  @protected
  bool isOutdated = true;
  StreamSubscription? _outdatedSubscription;

  AplRepository(this.timeToLiveMillis);

  Future<Either<bool>> _loadWith(UseCase<void, T> useCase) async {
    logMethod("loadWith", params: [useCase]);

    _markAsUpdating();

    final completer = Completer<Either<bool>>();
    await _cancelableOperation?.cancel();
    _cancelableOperation =
        CancelableOperation.fromFuture(useCase.call(null)).then((data) {
          onNewData(data);
          completer.complete(Either.withValue(true));
        }, onError: (error, stacktrace) {
          logError("applyInitial cause error", ex: error, stacktrace: stacktrace);
          completer.complete(Either.withError(error));
        }, onCancel: () {
          completer.complete(Either.withValue(false));
        });

    return completer.future.whenComplete(() => _cancelableOperation = null);
  }

  Future<Either<bool>> _loadIfOutdatedWith(UseCase<void, T> useCase) {
    logMethod("loadIfOutdatedWith", params: [useCase]);

    if (isOutdated) {
      return _loadWith(useCase);
    } else {
      return Future.value(Either.withValue(false));
    }
  }

  Future<Either<bool>> _changeWith(UseCase<T, T> operation,
      {resetOperationsStack = false}) async {
    logMethod("_changeWith", params: [operation, resetOperationsStack]);

    _markAsUpdating();

    final completer = Completer<Either<bool>>();
    if (resetOperationsStack || _cancelableOperation == null) {
      await _cancelableOperation?.cancel();
      if (!data.hasValue) {
        return Either.withValue(false);
      }

      final dataValue = data.value!;
      _cancelableOperation =
          CancelableOperation.fromFuture(operation.call(dataValue)).then(
                  (data) {
                onNewData(data);
                completer.complete(Either.withValue(true));
              }, onError: (error, stacktrace) {
            logError("apply cause error", ex: error, stacktrace: stacktrace);
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
          logError("apply cause error", ex: error, stacktrace: stacktrace);
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
    logMethod("cancelCurrentOperation");

    if (_cancelableOperation == null) {
      return false;
    }
    await _cancelableOperation!.cancel();
    _cancelableOperation = null;
    return true;
  }

  @protected
  void onNewData(T value) {
    logMethod("onNewData", params: [value]);

    data.sink.add(value);

    if (timeToLiveMillis > 0) {
      _outdatedSubscription =
          Future.delayed(Duration(milliseconds: timeToLiveMillis))
              .asStream()
              .listen((val) {
            isOutdated = true;
          });
    } else {
      isOutdated = true;
    }
  }

  void _markAsUpdating() {
    _outdatedSubscription?.cancel();
    _outdatedSubscription = null;
    isOutdated = false;
  }

  void markAsOutdated() {
    logMethod("markAdOutdated");

    _outdatedSubscription?.cancel();
    _outdatedSubscription = null;
    isOutdated = true;
  }

  void close() {
    logMethod("close");

    data.close();
  }
}

abstract class SideEffect<M> {
  Future<Either<bool>> apply(AplRepository<M> repo);

  factory SideEffect.load(UseCase<void, M> loadingUseCase) =>
      Load<M>._(loadingUseCase);

  factory SideEffect.update(UseCase<void, M> updatingUseCase) =>
      Update<M>._(updatingUseCase);

  factory SideEffect.change(UseCase<M, M> changingUseCase) =>
      Change<M>._(changingUseCase);

  factory SideEffect.post(UseCase<M, bool> sendingUseCase) =>
      Post<M>._(sendingUseCase);

  SideEffect._();
}

class Load<M> extends SideEffect<M> {
  final UseCase<void, M> sourceUseCase;

  Load._(this.sourceUseCase) : super._();

  @override
  Future<Either<bool>> apply(AplRepository<M> repo) {
    return repo._loadWith(sourceUseCase);
  }
}

class Update<M> extends SideEffect<M> {
  final UseCase<void, M> updateUseCase;

  Update._(this.updateUseCase) : super._();

  @override
  Future<Either<bool>> apply(AplRepository<M> repo) {
    return repo._loadIfOutdatedWith(updateUseCase);
  }
}

class Change<M> extends SideEffect<M> {
  final UseCase<M, M> changingUseCase;

  Change._(this.changingUseCase) : super._();

  @override
  Future<Either<bool>> apply(AplRepository<M> repo) {
    return repo._changeWith(changingUseCase);
  }
}

class Post<M> extends SideEffect<M> {
  final UseCase<M, bool> sendingUseCase;

  Post._(this.sendingUseCase) : super._();

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
