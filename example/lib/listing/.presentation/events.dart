abstract class ListingScreenEvents extends BaseWidgetEvents
    with Union2<_RemoveItem, _AddItem> {

  ListingScreenEvents._(String name) : super(name);

  factory ListingScreenEvents.removeItem(int id) => _RemoveItem(id);

  factory ListingScreenEvents.addItem(ItemModel model) => _AddItem(model);
}

class _RemoveItem extends ListingScreenEvents {
  final int id;

  _RemoveItem(this.id) : super._("remove_item");
}

class _AddItem extends ListingScreenEvents {

  final ItemModel model;

  _AddItem(this.model) : super._("add_item", []);
}