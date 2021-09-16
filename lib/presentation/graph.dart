
import 'package:applithium_core/domain/repository.dart';

import 'base_bloc.dart';

class DomainGraphEdge<M, S extends BaseState<M>> {
  final S? nextState;
  final SideEffect<M>? sideEffect;
  final S Function()? resultStateOnSuccess;
  final S Function()? resultStateOnCancel;
  final S Function(dynamic)? resultStateOnError;

  DomainGraphEdge._({this.nextState,
    this.sideEffect,
    this.resultStateOnSuccess,
    this.resultStateOnCancel,
    this.resultStateOnError});

  factory DomainGraphEdge.toState(S nextState) =>
      DomainGraphEdge._(nextState: nextState);

  factory DomainGraphEdge.withSideEffect(SideEffect<M>? sideEffect,
      {S Function()? onSuccess,
        S Function()? onCancel,
        S Function(dynamic)? onError}) =>
      DomainGraphEdge._(
          sideEffect: sideEffect,
          resultStateOnSuccess: onSuccess,
          resultStateOnCancel: onCancel,
          resultStateOnError: onError);
}

typedef DomainGraph<E extends WidgetEvents, M, S extends BaseState<M>>
= DomainGraphEdge<M, S>? Function(S, E);

DomainGraph<WidgetEvents,
    M,
    S> combine2<E1 extends WidgetEvents, E2 extends WidgetEvents, M, S extends BaseState<
    M>>(DomainGraph<E1, M, S> first, DomainGraph<E2, M, S> second) =>
        (state, event) {
      if (event is E1) {
        return first.call(state, event);
      } else if (event is E2) {
        return second.call(state, event);
      } else {
        return null;
      }
    };

DomainGraph<WidgetEvents,
    M,
    S> combine3<E1 extends WidgetEvents, E2 extends WidgetEvents, E3 extends WidgetEvents, M, S extends BaseState<
    M>>(DomainGraph<E1, M, S> first, DomainGraph<E2, M, S> second,
    DomainGraph<E3, M, S> third) =>
        (state, event) {
      if (event is E1) {
        return first.call(state, event);
      } else if (event is E2) {
        return second.call(state, event);
      } else if (event is E3) {
        return third.call(state, event);
      } else {
        return null;
      }
    };