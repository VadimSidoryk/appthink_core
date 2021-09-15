import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/listing/domain.dart';
import 'package:applithium_core/mocks/utils.dart';
import 'package:applithium_core/unions/union_2.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/list/remove_items.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:applithium_core_example/listing/model.dart';

abstract class ListingScreenEvents extends BaseListEvents
    with Union2<_RemoveItem, _AddItem> {
  ListingScreenEvents._(String name) : super(name);

  factory ListingScreenEvents.removeItem(int id) => _RemoveItem(id);
}

class _RemoveItem extends ListingScreenEvents {
  final int id;

  _RemoveItem(this.id) : super._("remove_item");
}

class _AddItem extends ListingScreenEvents {
  _AddItem() : super._("add_item");
}

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
  return removeItems((item) => item.id == id);
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
