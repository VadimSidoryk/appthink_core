import 'dart:async';

typedef UseCase<I, O, P> = FutureOr<O> Function(I, P);

extension Partial<I, O, P> on UseCase<I, O, P> {
  FutureOr<O> Function(I) partial(P params) {
    return (state) => this.call(state, params);
  }
}

