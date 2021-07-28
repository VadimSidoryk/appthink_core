import 'dart:async';

typedef UseCase<I, O> = Future<O> Function(I);

typedef UseCaseWithParams<I, O, P> = Future<O> Function(I, P);

extension Partial<I, O, P> on UseCaseWithParams<I, O, P> {
  UseCase<I, O> withParams(P params) {
    return (state) => this.call(state, params);
  }
}

