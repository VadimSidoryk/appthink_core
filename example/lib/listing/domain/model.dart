import 'package:applithium_core/domain/listing/model.dart';

class ExampleItemModel {
  final int id;
  final String title;

  ExampleItemModel(this.id, this.title);
}

class ExampleListingModel extends WithList<ExampleItemModel> {
  final List<ExampleItemModel> items;

  ExampleListingModel(this.items);
}