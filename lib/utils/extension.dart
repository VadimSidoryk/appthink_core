import 'dart:async';

import 'package:async/async.dart';
import 'package:appthink_core/logs/extension.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

extension ObjectExt on dynamic {
  void as<R>(Function(R that) op) {
    if (this is R) {
      op(this as R);
    }
  }
}

extension TypeExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

class LogInfo {
  final Object holder;
  final String methodName;
  final List<dynamic> params;

  LogInfo(this.holder, this.methodName, this.params);
}

Future<Result<T>> safeCall<T>(FutureOr<T> Function() function,
    {LogInfo? info, Function(dynamic)? onError}) async {
  try {
    final result = await function.call();
    info?.let((val) =>
        val.holder.logMethodResult(val.methodName, val.params, result));
    return Result.value(result);
  } catch (e, stacktrace) {
    info?.let((val) => val.holder.logError(val.methodName, e, stacktrace));
    try {
      onError?.call(e);
    } catch (e) {
      info?.let((val) => val.holder.logError(val.methodName, e, stacktrace));
    }
    return Result.error(e);
  }
}

extension LoggableSevice on Object {
  Future<Result<T>> call<T>(
      String methodName, List<dynamic> params, FutureOr<T> Function() function,
      {Function(dynamic)? onError}) {
    return safeCall(function,
        info: LogInfo(this, methodName, params), onError: onError);
  }
}

extension UpdatableValue<T> on BehaviorSubject<T> {
  void update(T Function(T) updater) async {
    final value = await first;
    try {
      final newValue = updater.call(value);
      add(newValue);
    } catch (e) {
      logError("update", e);
    }
  }
}

extension UpdatablePresentation<T> on Stream<T> {
  Widget view(Widget Function(T) provider,
      {WidgetBuilder? loadingBuilder,
      Widget Function(BuildContext, dynamic)? errorBuilder}) {

    final _ValueFromStream<T> initialData;
    if (this is ValueStream<T> && (this as ValueStream<T>).hasValue) {
      final valueStream = this as ValueStream<T>;
      initialData =
          _ValueFromStream(valueStream.valueOrNull, _StreamState.ACTIVE);
    } else {
      initialData = _ValueFromStream(null, _StreamState.EMPTY);
    }

    return StreamBuilder<_ValueFromStream<T>>(
      stream: this
          .distinct()
          .map((it) => _ValueFromStream(it, _StreamState.ACTIVE)),
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data == null) {
          logError(snapshot.error?.toString() ?? "Unknown error");
          return errorBuilder?.call(context, snapshot.error) ?? Container();
        }

        final dataFromStream = snapshot.data!;
        if (dataFromStream.state == _StreamState.EMPTY) {
          log("loading");
          return loadingBuilder?.call(context) ?? Container();
        } else {
          final data = dataFromStream.value;
          if (null is T) {
            return (provider as Function(T?)).call(data);
          }

          if (data == null) {
            final error = NullThrownError();
            logError(error.toString());
            return errorBuilder?.call(context, snapshot.error) ?? Container();
          } else {
            return provider.call(data);
          }
        }
      },
    );
  }
}

extension ResultChecker<T> on Result<T> {
  T get valueOrError {
    if (isError) {
      throw asError!.error;
    } else {
      return asValue!.value;
    }
  }
}

class _ValueFromStream<T> {
  final T? value;
  final _StreamState state;

  _ValueFromStream(this.value, this.state);
}

enum _StreamState { EMPTY, ACTIVE }
