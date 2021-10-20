import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/domain/use_case.dart';

import 'model.dart';

final ExampleListingModel _testModel = ExampleListingModel(
  [
    ExampleItemModel(1, "First"),
    ExampleItemModel(2, "Second"),
    ExampleItemModel(3, "Third"),
    ExampleItemModel(4, "Fourth"),
    ExampleItemModel(5, "Fifth"),
    ExampleItemModel(6, "Sixth"),
    ExampleItemModel(7, "Seventh"),
    ExampleItemModel(8, "Eighth"),
  ]
);

final testListingUseCases = ListingUseCases<ExampleItemModel, ExampleListingModel>(
  load: value(value: _testModel, delayMillis: 2000),
  update: value(value: _testModel, delayMillis: 2000),
  loadMore: value(value: _testModel, delayMillis: 2000)
);