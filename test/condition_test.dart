import 'package:applithium_core/json/condition.dart';
import 'package:test/test.dart';

void main() {
  test("1 == 0 -> false test", () {
    final sampleFalseConditionString = "1 == 0";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });
  test("12 == 12 -> true test", () {
    final sampleFalseConditionString = "12 == 12";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("abc == abs -> false test", () {
    final sampleFalseConditionString = "abc == abs";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("abc == abc -> true test", () {
    final sampleFalseConditionString = "abc == abc";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("abc != abc -> false test", () {
    final sampleFalseConditionString = "abc != abc";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("abc != abs -> true test", () {
    final sampleFalseConditionString = "abc != abs";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("1 < 3 -> true test", () {
    final sampleFalseConditionString = "1 < 3";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("3 < 1 -> false test", () {
    final sampleFalseConditionString = "3 < 1";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("4 % 2 -> 0 test", () {
    final sampleFalseConditionString = "4 % 2";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == 0);
  });

  test("3 % 2 -> 1 test", () {
    final sampleFalseConditionString = "3 % 2";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == 1);
  });

  test("3 % 2 == 1 -> true test", () {
    final sampleFalseConditionString = "3 % 2 == 1";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("3 % 2 > 2 -> false test", () {
    final sampleFalseConditionString = "3 % 2 > 2";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

  test("value1,value2,value3 contains value1 -> true test", () {
    final sampleFalseConditionString = "value1,value2,value3 contains value1";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == true);
  });

  test("value1,value2,value3 contains value4 -> false test", () {
    final sampleFalseConditionString = "value1,value2,value3 contains value4";
    final condition = Condition.fromString(sampleFalseConditionString);
    assert (condition.evaluate() == false);
  });

}
