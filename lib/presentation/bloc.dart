
import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';

abstract class AplBloc<S> extends Bloc<WidgetEvents, S> {
  @override
  Stream<S> get stream => _stateSubj;

  final _subscriptions = CompositeSubscription();
  late BehaviorSubject<S> _stateSubj;

  final S? Function(S, dynamic) errorHandler;

  AplBloc(S initialState, {required this.errorHandler}) : super(initialState) {
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
  }

  void doOn<E extends WidgetEvents>(EventHandler<E, S> handler,
      {EventTransformer<E>? transformer}) {
    final methodName = "doOn";
    on<E>((event, emit) async {
      try {
        await handler.call(event, emit);
      } catch (e, stacktrace) {
        logError(methodName, e, stacktrace);
        final newState = errorHandler.call(state, e);
        if(newState != null) {
          super.add(BaseWidgetEvents.changeStateWith((S state) => newState));
        }
      }
    }, transformer: transformer);
  }

  void bind<T>(Stream<T> stream, FutureOr<S> Function(S, T) stateProvider) {
    addSubscription(stream.listen((event) {
      final changer = (S state) async {
        try {
          return await stateProvider.call(state, event);
        } catch (e) {
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

extension BindUtils<S> on AplBloc<S> {
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
