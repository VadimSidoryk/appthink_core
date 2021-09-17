import 'package:applithium_core/domain/listing/use_cases';
import 'package:applithium_core/usecases/list/remove_items.dart';
import 'package:applithium_core/usecases/list/add_item.dart';

class ExampleListingUseCases extends ListingUseCases<ExampleListItem> {
  final UseCase<ExampleList, WithList<ExampleItemModel>> Function(int) removeItemById;
  final UseCase<WithList<ExampleItemModel>, WithList<ExampleItemModel>> Function(ExampleItemModel) addItem;

  ExampleListingUseCases({required this.removeItemById, required this.addItem, UseCase<void, M> load, UseCase<> }): super();
}

final testListingUseCases = ExampleListingUseCases(
  removeItemById: (id) => removeItems((item) => item.id == id),
  addItem: (item) => listAddItem(item)
);

