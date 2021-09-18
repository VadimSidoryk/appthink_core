import 'package:applithium_core/domain/repository.dart';

import 'base_bloc.dart';


class DomainGraphEdge<M, S1 extends BaseState<M>, S2 extends BaseState<M>> {
  final S1? nextState;
  final SideEffect<M>? sideEffect;
  final S2 Function(S1)? resultStateOnSuccess;
  final S2 Function(S1)? resultStateOnCancel;
  final S2 Function(S1, dynamic)? resultStateOnError;

  DomainGraphEdge._(
      {this.nextState,
      this.sideEffect,
      this.resultStateOnSuccess,
      this.resultStateOnCancel,
      this.resultStateOnError});

  factory DomainGraphEdge.toState<M, S2>(S2 state) {
    return DomainGraphEdge<M, dynamic, S2>._(nextState: state);
  }
}

typedef DomainGraph<M, S extends BaseState<M>> = DomainGraphEdge<M, S>?
    Function(S, WidgetEvents);

DomainGraph<M, S> combine2<M, S extends BaseState<M>>(
        DomainGraph<M, S> first, DomainGraph<M, S> second) =>
    (state, event) {
      final result = first.call(state, event);
      if (result == null) {
        return second.call(state, event);
      } else {
        return result;
      }
    };
