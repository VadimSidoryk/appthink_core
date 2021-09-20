import 'package:applithium_core/domain/listing/model.dart';

class ItemModel {
  final int id;
  final String title;

  ItemModel(this.id, this.title);
}

class ListingModel extends WithList<ItemModel> {
  final List<ItemModel> items;

  ListingModel(this.items);
}