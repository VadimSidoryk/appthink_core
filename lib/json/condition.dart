class Condition {
  final Object first;
  final Object second;
  final Operators operator;

  factory Condition.fromString(String initialValue) {
    final values = initialValue.split(" ");
    if(values.length < 3) {
      throw "Illegal count of arguments = ${values.length}";
    }
    var conditionLength = 3;
    Condition result;

    var firstValue = int.tryParse(values[0]) ?? values[0];
    var operator = values[1].asOperator();
    var secondValue = int.tryParse(values[2]) ?? values[2];

    result = Condition(firstValue, secondValue, operator);
    while(values.length > conditionLength) {
      operator = values[conditionLength].asOperator();
      secondValue = int.tryParse(values[conditionLength + 1]) ?? values[conditionLength + 1];
      result = Condition(result, secondValue, operator);
      conditionLength += 2;
    }

    return result;
  }


  Condition(this.first, this.second, this.operator);

  Object evaluate() {
    final firstValue;
    if (first is Condition) {
      firstValue = (first as Condition).evaluate();
    } else {
      firstValue = first;
    }

    final secondValue = second;

    if (!operator.canApplyTo(firstValue, secondValue)) {
      throw "Can't apply operator $operator to $firstValue or $secondValue";
    }

    return operator.evaluate(firstValue, secondValue);
  }
}

enum Operators {
  EQUALS,
  NOT_EQUALS,
  LESS,
  LESS_OR_EQUALS,
  MORE,
  MORE_OR_EQUALS,
  MOD,
  CONTAINS
}

extension OperatorFactory on String {
  Operators asOperator() {
    switch (this) {
      case "==":
        return Operators.EQUALS;
      case "!=":
        return Operators.NOT_EQUALS;
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
        throw "Can't parse \"$this\" to operator";
    }
  }
}

extension Operations on Operators {

  Object evaluate(Object firstValue, Object secondValue) {
    switch (this) {
      case Operators.EQUALS:
        return firstValue == secondValue;
      case Operators.NOT_EQUALS:
        return firstValue != secondValue;
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
    switch (this) {
      case Operators.CONTAINS:
        return firstValue is String && secondValue is String;
      case Operators.EQUALS:
      case Operators.NOT_EQUALS:
        return (firstValue is String && secondValue is String) ||
            (firstValue is int && secondValue is int);
      default:
        return firstValue is int && secondValue is int;
    }
  }
}
