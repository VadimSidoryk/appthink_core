class Either<T> {
  final T? value;
  final Object? exception;

  Either._(this.value, this.exception);

  factory Either.withValue(T value)  => Either._(value, null);

  factory Either.withError(Object e) => Either._(null, e);

  void forEach(Function(T) onSuccess, Function(dynamic) onError) {
    if(value != null) {
      onSuccess.call(value!);
    } else {
      onError.call(exception);
    }
  }

  Result fold<Result>(
      Result Function(T) first, Result Function(dynamic) second) {
    if(value != null) {
      return first.call(value!);
    } else {
      return second.call(exception);
    }
  }
}