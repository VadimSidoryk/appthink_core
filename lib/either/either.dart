import 'package:applithium_core/unions/union_2.dart';

class Either<T> with Union2<T, dynamic> {
  final T? value;
  final Object? exception;

  Either._(this.value, this.exception);

  factory Either.withValue(T value)  => Either._(value, null);

  factory Either.withError(Object e) => Either._(null, e);
}