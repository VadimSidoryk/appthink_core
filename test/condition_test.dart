import 'package:appthink_core/utils/json/condition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("1 == 0 -> false content", () {
    final sampleFalseConditionString = "1 == 0";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });
  test("12 == 12 -> true content", () {
    final sampleFalseConditionString = "12 == 12";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("abc == abs -> false content", () {
    final sampleFalseConditionString = "abc == abs";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("abc == abc -> true content", () {
    final sampleFalseConditionString = "abc == abc";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("abc != abc -> false content", () {
    final sampleFalseConditionString = "abc != abc";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("abc != abs -> true content", () {
    final sampleFalseConditionString = "abc != abs";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("1 < 3 -> true content", () {
    final sampleFalseConditionString = "1 < 3";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("3 < 1 -> false content", () {
    final sampleFalseConditionString = "3 < 1";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("4 % 2 -> 0 content", () {
    final sampleFalseConditionString = "4 % 2";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == 0);
  });

  test("3 % 2 -> 1 content", () {
    final sampleFalseConditionString = "3 % 2";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == 1);
  });

  test("3 % 2 == 1 -> true content", () {
    final sampleFalseConditionString = "3 % 2 == 1";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("3 % 2 > 2 -> false content", () {
    final sampleFalseConditionString = "3 % 2 > 2";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("value1,value2,value3 contains value1 -> true content", () {
    final sampleFalseConditionString = "value1,value2,value3 contains value1";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("value1,value2,value3 contains value4 -> false content", () {
    final sampleFalseConditionString = "value1,value2,value3 contains value4";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });
}