import 'package:applithium_core/utils/mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("test mock nullable primitive", () {
    final factory = MocksFactory();
    final values = factory.listFastVariants(String);
    print(values);
  });

  test("test inner function getValuesRangeType", () {
    final factory = MocksFactory()
      ..addGenerator(
          (mocker) => _SimpleClassWithNullableField(mocker.nullable()));
    final objValues =
        factory.getValuesRangeForField<String>(ObjectType(String));
    print("type = ${objValues.runtimeType}");
    print("value = $objValues");
    final listValues = factory.getValuesRangeForField(ListType(String));
    print(listValues);
    final setValues = factory.getValuesRangeForField(SetType(String));
    print(setValues);
    final mapValues = factory.getValuesRangeForField(MapType(int, String));
    print(mapValues);
  });

  test("test inner function getValuesRangeType nullable object rule", () {
    final factory = MocksFactory()
      ..addGenerator(
              (mocker) => _SimpleClassWithNullableField(mocker.nullable(rule: (it) => (it?.length ?? 0) > 10)));
    print(factory.getValuesRangeType(_SimpleClassWithNullableField));
  });

  test("test inner function getValuesRangeType notNull object rule", () {
    final factory = MocksFactory()
      ..addGenerator(
              (mocker) => _SimpleClassWithNotNullField(mocker.notNull(rule: (it) => it.length > 10)));
    print(factory.getValuesRangeType(_SimpleClassWithNotNullField));
  });

  test("test nullable collection rule", () {
    final factory = MocksFactory()
      ..addGenerator(
              (mocker) => _SimpleClassWithNullableCollectionField(mocker.notNullList<String>(rule: (it) => it.length > 0)
                  .where((element) => element != null)
                  .map((e) => e as String)
                  .toList()));
     print(factory.getValuesRangeType(_SimpleClassWithNullableCollectionField));
  });

  test("test notNull collection rule", () {
    final factory = MocksFactory()
      ..addGenerator(
              (mocker) => _SimpleClassWithNullableCollectionField(mocker.notNullList<String>(rule: (it) => it.length > 0)
                  .where((element) => element != null)
                  .map((e) => e as String)
                  .toList()));
    print(factory.getValuesRangeType(_SimpleClassWithNullableCollectionField));
  });

  test("test inner function getValuesRangeForField :  mock collections of primitives", () {
    final factory = MocksFactory();
    final objValues =
    factory.getValuesRangeForField<String>(ObjectType(String));
    print("type = ${objValues.runtimeType}");
    print("value = $objValues");
    final listValues = factory.getValuesRangeForField(ListType(String));
    print(listValues);
    final setValues = factory.getValuesRangeForField(SetType(String));
    print(setValues);
    final mapValues = factory.getValuesRangeForField(MapType(int, String));
    print(mapValues);
  });

  test("test inner function getValuesRangeForField : ", () {
    final factory = MocksFactory()
      ..addGenerator(
          (mocker) => _SimpleClassWithNullableField(mocker.nullable()))
      ..addGenerator(
          (mocker) => _SimpleClassWithTwoNullableFields(mocker.nullable(), mocker.notNullList<String>()
          .where((element) => element != null)
          .map((e) => e as String)
          .toList()))
      ..addGenerator(
              (mocker) => _SimpleClassWithNotNullField(mocker.notNull()));
     // ..addGenerator((mocker) => _SimpleClassWithTwoNotNullFields(mocker.getNotNull(), mocker.getList((List<String?>? list) => list != null)));

    print("one nullable field range = ${factory.getValuesRangeType(_SimpleClassWithNullableField)}");
    print("two nullable fields range = ${factory.getValuesRangeType(_SimpleClassWithTwoNullableFields)}");
    print("one notNull field range = ${factory.getValuesRangeType(_SimpleClassWithNotNullField)}");

    // print("two nonNull fields range = ${factory.getValuesRangeType(_SimpleClassWithTwoNotNullFields)}");

  });

  test("test undefined class", () {
    final factory = MocksFactory();
    expect(() => factory.listFastVariants(_SimpleClassWithTwoNullableFields),
        throwsA(isA<String>()));
  });

  test("test generate class without param", () {
    final factory = MocksFactory()
        ..addGenerator((mocker) => DateTime.now());
    final values = factory.listFastVariants(DateTime);
    print(values);
  });

  test("test generate nullable field", () {
    final factory = MocksFactory()
      ..addGenerator(
              (mocker) => _SimpleClassWithNullableField(mocker.nullable()));
    final values = factory.listFastVariants(_SimpleClassWithNullableField);
    print(values);
  });

  test("test generate notNull field", () {
    final factory = MocksFactory()
      ..addGenerator(
              (mocker) => _SimpleClassWithNotNullField(mocker.notNull()));
     final values = factory.listFastVariants(_SimpleClassWithNotNullField);
    // print(values);
  });
}

class _SimpleClassWithNullableField {
  final String? nullableField;

  _SimpleClassWithNullableField(this.nullableField);
}

class _SimpleClassWithNotNullField {
  final String notNullField;

  _SimpleClassWithNotNullField(this.notNullField);
}

class _SimpleClassWithNullableCollectionField {
  final List<String>? nullableCollection;

  _SimpleClassWithNullableCollectionField(this.nullableCollection);
}

class _SimpleClassWithNotNullCollectionField {
  final List<String> notNullField;

  _SimpleClassWithNotNullCollectionField(this.notNullField);
}

class _SimpleClassWithTwoNullableFields {
  final String? nullableField;
  final List<String>? nullableCollectionField;

  _SimpleClassWithTwoNullableFields(this.nullableField, this.nullableCollectionField);
}

class _SimpleClassWithTwoNotNullFields {
  final String notNullField;
  final List<String> notNullCollection;

  _SimpleClassWithTwoNotNullFields(this.notNullField, this.notNullCollection);

}
