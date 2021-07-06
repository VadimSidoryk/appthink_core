class Condition {
  final Object first;
  final Object second;
  final Operators operator;

  Condition(this.first, this.second, this.operator);

  Object evaluate() {
    if(!operator.canApplyTo(first, second)) {
      throw "Can't apply operator $operator to $first or $second";
    }

    return operator.evaluate(first, second);
  }

}

enum Operators {
  EQUALS,
  LESS,
  LESS_OR_EQUALS,
  MORE,
  MORE_OR_EQUALS,
  MOD,
  CONTAINS
}

extension Symbols on Operators {
  static Operators? fromString(String operatorString) {
    switch (operatorString) {
      case "==":
        return Operators.EQUALS;
      case "<":
        return Operators.LESS;
      case "<=":
        return Operators.LESS_OR_EQUALS;
      case ">":
        return Operators.MORE;
      case ">=":
        return Operators.MORE_OR_EQUALS;
      case "%":
        return Operators.MOD;
      case "contains":
        return Operators.CONTAINS;
      default:
        return null;
    }
  }

  Object evaluate(Object firstValue, Object secondValue) {
    switch(this) {
      case Operators.EQUALS:
        return firstValue == secondValue;
      case Operators.CONTAINS:
        return (firstValue as String).contains(secondValue as String);
      case Operators.LESS:
        return (firstValue as int) < (secondValue as int);
      case Operators.LESS_OR_EQUALS:
        return (firstValue as int) <= (secondValue as int);
      case Operators.MORE:
        return (firstValue as int) > (secondValue as int);
      case Operators.MORE_OR_EQUALS:
        return (firstValue as int) >= (secondValue as int);
      case Operators.MOD:
        return (firstValue as int) % (secondValue as int);
    }
  }

  bool canApplyTo(Object firstValue, Object secondValue) {
    switch(this) {
      case Operators.CONTAINS:
        return firstValue is String && secondValue is String;
      case Operators.EQUALS:
        return (firstValue is String && secondValue is String) || (firstValue is int && secondValue is int);
      default:
        return firstValue is int && secondValue is int;
    }
  }
}
