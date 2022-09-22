import 'dart:async';

import 'package:async/async.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

import '../presentation/widget.dart';

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

class LogInfo {
  final Object holder;
  final String methodName;
  final List<Object> params;

  LogInfo(this.holder, this.methodName, [this.params = const []]);
}

Future<Result<T>> safeCall<T>(FutureOr<T> Function() function,
    {LogInfo? info, Function(dynamic)? onError}) async {
  try {
    info?.let((val) => val.holder.logMethod(val.methodName, params: val.params));
    final result = await function.call();
    info?.let((val) => result?.logResult(val.holder, val.methodName));
    return Result.value(result);
  } catch (e, stacktrace) {
    info?.let((val) =>  val.holder.logError(val.methodName, e, stacktrace));
    try {
      onError?.call(e);
    } catch(e) {
      info?.let((val) => val.holder.logError(val.methodName, e, stacktrace));
    }
    return Result.error(e);
  }
}

extension UpdatablePresentation<T> on Stream<T> {
  Widget view(Widget Function(T) provider,
      {WidgetBuilder? loadingBuilder,
      Widget Function(BuildContext, dynamic)? errorBuilder}) {
    return StreamBuilder<_ValueFromStream<T>>(
      stream: this
          .distinct()
          .map((it) => _ValueFromStream(it, _StreamState.ACTIVE)),
      initialData: _ValueFromStream(null, _StreamState.EMPTY),
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
    if(isError) {
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

extension ResourceProvider<R extends AplWidgetResources, W extends AplWidget<R>> on State<W> {
  R get res {
    if(widget.resources != null) {
      return widget.resources!;
    }  else {
      widget.resources = widget.resourceProvider.call(context, widget);
      return widget.resources!;
    }
  };
}