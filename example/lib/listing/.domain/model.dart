class ExampleListItemModel {
  final int id;
  final String title;
}

class ExampleListModel extends WithList<ExampleListItemModel> {
  final List<ExampleListItemModel> items;

  ExampleListModel(this.items);
}