mixin Union6<First, Second, Third, Fourth, Fifth, Sixth> {
  void forEach(
      Function(First) first,
      Function(Second) second,
      Function(Third) third,
      Function(Fourth) fourth,
      Function(Fifth) fifth,
      Function(Sixth) sixth) {
    if (this is First) {
      first.call(this as First);
    } else if (this is Second) {
      second.call(this as Second);
    } else if (this is Third) {
      third.call(this as Third);
    } else if (this is Fourth) {
      fourth.call(this as Fourth);
    } else if (this is Fifth) {
      fifth.call(this as Fifth);
    } else if (this is Sixth) {
      sixth.call(this as Sixth);
    } else {
      throw "Illegal usage of Union";
    }
  }

  Result fold<Result>(
      Result Function(First) first,
      Result Function(Second) second,
      Result Function(Third) third,
      Result Function(Fourth) fourth,
      Result Function(Fifth) fifth,
      Result Function(Sixth) sixth) {
    if (this is First) {
      return first.call(this as First);
    } else if (this is Second) {
      return second.call(this as Second);
    } else if (this is Third) {
      return third.call(this as Third);
    } else if (this is Fourth) {
      return fourth.call(this as Fourth);
    } else if (this is Fifth) {
      return fifth.call(this as Fifth);
    } else if (this is Sixth) {
      return sixth.call(this as Sixth);
    } else {
      throw "Illegal usage of Union";
    }
  }
}
