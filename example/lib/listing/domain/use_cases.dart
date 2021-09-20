import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/usecases/mocks/value.dart';

import 'model.dart';

final ListingModel _testModel = ListingModel(
  [
    ItemModel(1, "First"),
    ItemModel(2, "Second"),
    ItemModel(3, "Third"),
    ItemModel(4, "Fourth"),
    ItemModel(5, "Fifth"),
    ItemModel(6, "Sixth"),
    ItemModel(7, "Seventh"),
    ItemModel(8, "Eighth"),
  ]
);

final testListingUseCases = ListingUseCases<ItemModel, ListingModel>(
  load: value(value: _testModel, delayMillis: 2000),
  update: value(value: _testModel, delayMillis: 2000),
  loadMore: value(value: _testModel, delayMillis: 2000)
);