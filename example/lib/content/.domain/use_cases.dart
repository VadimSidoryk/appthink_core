import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/mocks/value';
import 'model.dart';

class ContentScreenUseCases {
  final UseCase<void, ContentScreenModel> load;
  final UseCase<ContentScreenModel, ContentScreenModel> addLike;
  final UseCase<ContentScreenModel, ContentScreenModel> removeLike;
}

final testUseCases = ContentScreenUseCases(
  load: value(
      value: ContentScreenModel("sample title", "sample description", 2),
      delayMillis: 3000),
  addLike: (model) => model.copyWith(likes: model.likes + 1),
  removeLike: (model) => model.copyWith(likes: model.likes - 1);
);