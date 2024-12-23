import 'dart:async';

import 'package:appthink_core/logs/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';

typedef ErrorHandler<S> = S? Function(S, dynamic);

abstract class BlocCallbacks {
  List<Function(AplBloc)> get bindings;

  @protected
  Function(AplBloc) bind<E extends WidgetEvents>(Function() callback) =>
      (bloc) {
        bloc.doOn<E>((event, emit) => callback.call());
      };

  void applyTo(AplBloc bloc) {
    bindings.forEach((element) => element.call(bloc));
  }
}

abstract class AplBloc<S> extends Bloc<WidgetEvents, S> {
  @override
  Stream<S> get stream => _stateSubj;

  final _subscriptions = CompositeSubscription();
  late BehaviorSubject<S> _stateSubj;

  final ErrorHandler<S> errorHandler;
  final BlocCallbacks? callbacks;

  AplBloc(S initialState, {required this.errorHandler, this.callbacks})
      : super(initialState) {
    _stateSubj = BehaviorSubject<S>.seeded(initialState);
    super.stream.listen((it) {
      _stateSubj.add(it);
    });

    doOn<BaseWidgetEvents>((event, emit) async {
      if (event is ChangingInternalState<S>) {
        S nextState = await event.changer.call(state);
        emit(nextState);
      }
      onWidgetEvent(event);
    });

    callbacks?.applyTo(this);
  }

  void doOn<E extends WidgetEvents>(EventHandler<E, S> handler,
      {EventTransformer<E>? transformer}) {
    on<E>((event, emit) async {
      try {
        final _mockedEmitter = _MockedEmitter(emit, (newState) {
          logMethodResult("doOn", [event], newState);
        });
        await handler.call(event, _mockedEmitter);
      } catch (e, stacktrace) {
        logError("doOn", e, stacktrace);
        final newState = errorHandler.call(state, e);
        if (newState != null) {
          super.add(BaseWidgetEvents.changeStateWith((S state) => newState));
        }
      }
    }, transformer: transformer);
  }

  void bind<T>(Stream<T> stream, FutureOr<S> Function(S, T) stateProvider) {
    addSubscription(stream.listen((event) {
      final changer = (S state) async {
        try {
          final resultState = await stateProvider.call(state, event);
          logMethodResult("bind", [state, event], resultState);
          return resultState;
        } catch (e, stacktrace) {
          logError("bind", e, stacktrace);
          return errorHandler.call(state, e) ?? state;
        }
      };
      super.add(BaseWidgetEvents.changeStateWith(changer));
    }));
  }

  Stream<T> observe<T>(T Function(S) mapper) {
    return stream.map(mapper).distinct();
  }

  @protected
  void onWidgetEvent(WidgetEvents event) {}

  @override
  Future<void> close() async {
    _subscriptions.dispose();
    await super.close();
  }

  @protected
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }
}

class _MockedEmitter<State> extends Emitter<State> {
  final Emitter<State> source;
  final Function(State) callback;

  _MockedEmitter(this.source, this.callback);

  @override
  void call(State state) {
    try {
      callback.call(state);
    } catch (e, stacktrace) {
      logError("call returns error", e, stacktrace);
    }
    source.call(state);
  }

  @override
  Future<void> forEach<T>(Stream<T> stream,
      {required State Function(T data) onData,
      State Function(Object error, StackTrace stackTrace)? onError}) {
    return source.forEach(stream, onData: onData, onError: onError);
  }

  @override
  bool get isDone => source.isDone;

  @override
  Future<void> onEach<T>(Stream<T> stream,
      {required void Function(T data) onData,
      void Function(Object error, StackTrace stackTrace)? onError}) {
    return source.onEach(stream, onData: onData, onError: onError);
  }
}

extension StreamUtils<S> on AplBloc<S> {
  void bind2<T1, T2>(Stream<T1> stream1, Stream<T2> stream2,
      FutureOr<S> Function(S, T1, T2) stateProvider) {
    return bind(
        CombineLatestStream.list([stream1, stream2]),
        (state, List<dynamic> values) =>
            stateProvider.call(state, values[0] as T1, values[1] as T2));
  }

  void bind3<T1, T2, T3>(Stream<T1> stream1, Stream<T2> stream2,
      Stream<T3> stream3, FutureOr<S> Function(S, T1, T2, T3) stateProvider) {
    return bind(
        CombineLatestStream.list([stream1, stream2, stream3]),
        (state, List<dynamic> values) => stateProvider.call(
            state, values[0] as T1, values[1] as T2, values[2] as T3));
  }

  void bind4<T1, T2, T3, T4>(
      Stream<T1> stream1,
      Stream<T2> stream2,
      Stream<T3> stream3,
      Stream<T4> stream4,
      FutureOr<S> Function(S, T1, T2, T3, T4) stateProvider) {
    return bind(
        CombineLatestStream.list([stream1, stream2, stream3, stream4]),
        (state, List<dynamic> values) => stateProvider.call(
            state,
            values[0] as T1,
            values[1] as T2,
            values[2] as T3,
            values[3] as T4));
  }

  void bind5<T1, T2, T3, T4, T5>(
      Stream<T1> stream1,
      Stream<T2> stream2,
      Stream<T3> stream3,
      Stream<T4> stream4,
      Stream<T5> stream5,
      FutureOr<S> Function(S, T1, T2, T3, T4, T5) stateProvider) {
    return bind(
        CombineLatestStream.list([stream1, stream2, stream3, stream4, stream5]),
        (state, List<dynamic> values) => stateProvider.call(
            state,
            values[0] as T1,
            values[1] as T2,
            values[2] as T3,
            values[3] as T4,
            values[4] as T5));
  }
}
