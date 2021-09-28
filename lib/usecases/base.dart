import 'dart:async';

typedef UseCase<I, O> = Future<O> Function(I);

