
import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'state.dart';


abstract class AplBloc<S extends BaseState> extends Bloc<WidgetEvents, S> {
  @override
  Stream<S> get stream => _stateSubj;

  final _subscriptions = CompositeSubscription();
  late BehaviorSubject<S> _stateSubj;

  AplBloc(S initialState) : super(initialState) {
    _stateSubj = BehaviorSubject<S>.seeded(initialState);
    super.stream.listen((it) {
      _stateSubj.add(it);
    });

    doOn<BaseWidgetEvents>((event, emit) {
      if (event is ChangingInternalState<S>) {
        S nextState = event.changer.call(state);
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
        super.add(
            BaseWidgetEvents.changeStateWith((S state) => state.withError(e)));
      }
    }, transformer: transformer);
  }

  void bind<T>(Stream<T> stream, S Function(S, T) stateProvider) {
    addSubscription(stream.listen((event) {
      final changer = (S state) {
        try {
          return stateProvider.call(state, event);
        } catch (e) {
          return state.withError(e);
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

extension BindUtils<S extends BaseState> on AplBloc<S> {
  void bind2<T1, T2>(Stream<T1> stream1, Stream<T2> stream2,
      S Function(S, T1, T2) stateProvider) {
    return bind(
        CombineLatestStream.list([stream1, stream2]),
            (state, List<dynamic> values) =>
            stateProvider.call(state, values[0] as T1, values[1] as T2));
  }

  void bind3<T1, T2, T3>(Stream<T1> stream1, Stream<T2> stream2,
      Stream<T3> stream3, S Function(S, T1, T2, T3) stateProvider) {
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
      S Function(S, T1, T2, T3, T4) stateProvider) {
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
      S Function(S, T1, T2, T3, T4, T5) stateProvider) {
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
