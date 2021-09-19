import 'package:applithium_core/domain/repository.dart';

import 'base_bloc.dart';

typedef DomainGraph<M, S extends BaseState<M>> = DomainGraphEdge<M, S, S>? Function(S, WidgetEvents);

class DomainGraphEdge<M, S1 extends BaseState<M>, S2 extends BaseState<M>> {
  final S1? nextState;
  final SideEffect<M>? sideEffect;
  final S2 Function()? resultStateOnSuccess;
  final S2 Function()? resultStateOnCancel;
  final S2 Function(dynamic)? resultStateOnError;

  DomainGraphEdge(
      {this.nextState,
      this.sideEffect,
      this.resultStateOnSuccess,
      this.resultStateOnCancel,
      this.resultStateOnError});
}

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
