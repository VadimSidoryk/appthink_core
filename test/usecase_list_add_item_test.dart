import 'package:applithium_core/usecases/list/add_item.dart';
import 'package:test/test.dart';

void main() {
  final builder = (args) => TestModel(args["title"], args["subtitle"]);
  final addToEnd = ListAddItemUseCase(builder: builder, addToEnd: true);
  final addToTop = ListAddItemUseCase(builder: builder, addToEnd: false);

  test("add valid to end", () async {
    final addValidToEnd = addToEnd.withEventParams(createValidTestMap());

    final listWithOneItem = await addValidToEnd.invoke([]).first;
    assert(listWithOneItem.length == 1);
    final listWithTwoItems = await addValidToEnd.invoke([TestModel("first_title", "first_subtitle")]).first;
    assert(listWithTwoItems.length == 2);
    assert(listWithTwoItems[0].title == "first_title");
    assert(listWithTwoItems[1].title == "test_title");

  });

  test("add valid to top", () async {
    final addValidToTop = addToTop.withEventParams(createValidTestMap());

    expect(addValidToTop.invoke([]), emits(hasLength(1)));
    expect(addValidToTop.invoke([TestModel("first_title", "first_subtitle")]), emits(hasLength(2)));
  });

  test("add invalid", () async {
    final addInvalid = addToTop.withEventParams(createInvalidTestMap());
    expect(addInvalid.invoke([]), emitsError(isA<Error>()));
  });
}

Map<String, String> createValidTestMap() {
  return {"title": "test_title", "subtitle": "test_subtitle"};
}

Map<String, String> createInvalidTestMap() {
  return {"invalid_title_tag": "test_title"};
}

class TestModel {
  final String title;
  final String subtitle;

  TestModel(this.title, this.subtitle);
}
