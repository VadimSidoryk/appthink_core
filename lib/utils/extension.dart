import 'dart:async';

import 'package:async/async.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';


extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

extension FuctionExt<T> on T Function() {
  Result<T> safeCall(Object holder, String methodName, [List<Object> params = const []]) {
    try {
      holder.logMethod(methodName, params: params);
      return Result.value(this.call())..logResult(holder, methodName);
    } catch (e, stacktrace) {
      holder.logError(methodName, e, stacktrace);
      return Result.error(e);
    }
  }
}


  Future<Result<T>> safeCall<T>(Object holder, Future<T> Function() function, {String? methodName, List<Object> params = const []}) async {
  final _methodName = methodName ?? "undefined";
    try {
      holder.logMethod(_methodName, params: params);
      final result = await function.call();
      return Result.value(result?..logResult(holder, _methodName));
    } catch (e, stacktrace) {
      holder.logError(_methodName, e, stacktrace);
      return Result.error(e);
    }
  }


extension UpdatablePresentation<T> on Stream<T> {

  Widget view(Widget Function(T) provider, {WidgetBuilder? loadingBuilder, Widget Function(BuildContext, dynamic)? errorBuilder}) {
    return StreamBuilder<_ValueFromStream<T>>(
      stream: this.distinct().map((it) => _ValueFromStream(it, _StreamState.ACTIVE)),
      initialData: _ValueFromStream(null, _StreamState.EMPTY),
      builder: (context, snapshot) {
        if(snapshot.hasError || snapshot.data == null) {
          logError(snapshot.error?.toString() ?? "Unknown error");
          return errorBuilder?.call(context, snapshot.error) ?? Container();
        }

        final dataFromStream = snapshot.data!;
        if(dataFromStream.state == _StreamState.EMPTY) {
          log("loading");
          return loadingBuilder?.call(context) ?? Container();
        } else {
          final data = dataFromStream.value;
          if(null is T) {
            return (provider as Function(T?)).call(data);
          }

          if(data == null) {
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

class _ValueFromStream<T> {
  final T? value;
  final _StreamState state;

  _ValueFromStream(this.value, this.state);
}

enum _StreamState {
  EMPTY,
  ACTIVE
}


