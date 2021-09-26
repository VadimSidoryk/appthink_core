import 'package:applithium_core/domain/content/use_cases.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/mocks/error.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:applithium_core_example/content/domain/model.dart';

class ExampleContentUseCases extends ContentUseCases<ExampleContentModel> {
  final UseCase<ExampleContentModel, ExampleContentModel> addLike;
  final UseCase<ExampleContentModel, ExampleContentModel> removeLike;

  ExampleContentUseCases(
      {required this.addLike,
      required this.removeLike,
      required UseCase<void, ExampleContentModel> load,
      required UseCase<ExampleContentModel, ExampleContentModel> update})
      : super(load: load, update: update);
}

final testUseCases = ExampleContentUseCases(
  load: value(value: ExampleContentModel(title: "Test title", description: "Test descripion", likes: 10), delayMillis: 2000),
  update: value(value: ExampleContentModel(title: "Test title", description: "Test descripion", likes: 10), delayMillis: 2000),
  addLike: (model) async => model.copyWith(likes: model.likes + 1),
  removeLike: (model) async => model.copyWith(likes: model.likes - 1)
);

final errorUseCases = ExampleContentUseCases(
    load: error<ExampleContentModel>(delayMillis: 1000),
    update: value(value: ExampleContentModel(title: "Test title", description: "Test descripion", likes: 10), delayMillis: 2000),
    addLike: (model) async => model.copyWith(likes: model.likes + 1),
    removeLike: (model) async => model.copyWith(likes: model.likes - 1)
);
