import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/listing/bloc.dart';
import 'package:applithium_core/mocks/utils.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/list/remove_items.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:applithium_core_example/listing/model.dart';
import 'package:flutter/cupertino.dart';


abstract class ListingScreenEvents extends BaseListEvent {
  ListingScreenEvents._(String name) : super(name);

  factory ListingScreenEvents.removeItem(int id) => _RemoveItem(id);
}

class _RemoveItem extends ListingScreenEvents {
  final int id;

  _RemoveItem(this.id) : super._("remove_item");
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

final DomainGraph<List<ListItemModel>, ListingState<ListItemModel>>
    listingGraph = (state, event) {
  if (event is _RemoveItem) {
    final id = event.id;
    return DomainGraphEdge(sideEffect: removeItemsById(id));
  } else {
    return null;
  }
};

ListingBloc<ListItemModel> provideListingBloc(
    BuildContext context, Presenters presenters) {
  return ListingBloc(
      repository: context.get(),
      presenters: presenters,
      load: listLoader,
      loadMore: loadMore,
      customGraph: listingGraph);
}
