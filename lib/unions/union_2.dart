mixin Union2<First, Second> {
  void forEach(Function(First) first, Function(Second) second) {
    if (this is First) {
      first.call(this as First);
    } else if (this is Second) {
      second.call(this as Second);
    } else {
      throw "Illegal usage of Union";
    }
  }

  Result fold<Result>(
      Result Function(First) first, Result Function(Second) second) {
    if (this is First) {
      return first.call(this as First);
    } else if (this is Second) {
      return second.call(this as Second);
    } else {
      throw "Illegal usage of Union";
    }
  }
}
