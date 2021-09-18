import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core/presentation/graph.dart';
import 'package:applithium_core_example/content/domain/model.dart';
import 'package:applithium_core_example/content/domain/use_cases.dart';
import 'package:applithium_core_example/content/presentation/events.dart';

DomainGraph<ExampleContentEvents, ExampleContentModel,
    ContentScreenState<ExampleContentModel>> createExampleContentGraph(ExampleContentUseCases useCases) =>
    (state, event) {
      event.fold(
          (AddLike add) => DomainGraphEdge.withSideEffect(
              SideEffect.change(useCases.addLike)),
          (RemoveLike remove) => DomainGraphEdge.withSideEffect(
              SideEffect.change(useCases.removeLike)));
    };
