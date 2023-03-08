import 'dart:async';

import 'package:appthink_core/services/logger/service.dart';
import 'package:async/async.dart';
import 'package:appthink_core/logs/extension.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

extension ObjectExt on dynamic {
  R? as<R>(R? Function(R that) op) {
    if (this is R) {
      return op(this as R);
    } else {
      return null;
    }
  }
}

extension TypeExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}


Future<Result<T>> safeCall<T>(Object holder, FutureOr<T> Function() function,
    { String? methodName, List<String> params = const [], Function(dynamic)? onError}) async {
  try {
    final result = await function.call();
    holder.logMethodResult(methodName ?? "Undefined", params, result);
    return Result.value(result);
  } catch (e, stacktrace) {
    holder.logError("${methodName ?? "Undefined"} : $e", stacktrace);
    if (onError != null) {
      try {
        onError.call(e);
      } catch (e) {
        holder.logError("$methodName, onError: $e", stacktrace);
      }
    }

    return Result.error(e);
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
