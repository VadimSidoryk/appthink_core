import 'package:applithium_core/mocks/utils.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/list/remove_items.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:applithium_core_example/listing/model.dart';

final listLoader = value(
    value: MockUtils.generateItems(
        20, (index) => ListItemModel(index, "$index title", "$index subtitle")),
    delayMillis: 2000);

final UseCase<List<ListItemModel>, List<ListItemModel>> loadMore =
    (List<ListItemModel> prev) async {
  final lastIndex = prev.last.id;
  await Future.delayed(Duration(milliseconds: 2000));
  return MockUtils.generateItems(20, (index) {
    final realIndex = index + lastIndex + 1;
    return ListItemModel(realIndex, "$realIndex title", "$realIndex subtitle");
  });
};

UseCase<List<ListItemModel>, List<ListItemModel>> removeItemsById(int id) {
  return listRemoveItems((item) => item.id == id);
}

final DomainGraph<List<ListItemModel>, ListingScreenState<ListItemModel>>
    listingGraph =
    createListingGraph(listLoader, loadMore).plus((state, event) {
  if (event is ListingScreenEvents) {
    return event.fold(
        (removeItem) => DomainGraphEdge(
            sideEffect: SideEffect.change(removeItemsById(removeItem.id))),
        (addItem) => DomainGraphEdge());
  }
});
