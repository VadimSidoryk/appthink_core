mixin Union4<First, Second, Third, Fourth> {
  void forEach(Function(First) first, Function(Second) second,
      Function(Third) third, Function(Fourth) fourth) {
    if (this is First) {
      first.call(this as First);
    } else if (this is Second) {
      second.call(this as Second);
    } else if (this is Third) {
      third.call(this as Third);
    } else if (this is Fourth) {
      fourth.call(this as Fourth);
    } else {
      throw "Illegal usage of Union";
    }
  }

  Result fold<Result>(
      Result Function(First) first,
      Result Function(Second) second,
      Result Function(Third) third,
      Result Function(Fourth) fourth) {
    if (this is First) {
      return first.call(this as First);
    } else if (this is Second) {
      return second.call(this as Second);
    } else if (this is Third) {
      return third.call(this as Third);
    } else if (this is Fourth) {
      return fourth.call(this as Fourth);
    } else {
      throw "Illegal usage of Union";
    }
  }
}
