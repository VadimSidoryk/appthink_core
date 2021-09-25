
import 'package:applithium_core/domain/listing/model.dart';

class ExampleItemModel {
  final int id;
  final String title;

  ExampleItemModel(this.id, this.title);
}

class ExampleListingModel extends BaseListModel<ExampleItemModel> {
  final List<ExampleItemModel> items;

  ExampleListingModel(this.items);
}