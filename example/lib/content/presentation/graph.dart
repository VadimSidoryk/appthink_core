import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core/presentation/graph.dart';
import 'package:applithium_core_example/content/domain/model.dart';
import 'package:applithium_core_example/content/domain/use_cases.dart';
import 'package:applithium_core_example/content/presentation/events.dart';

DomainGraph<ExampleContentModel, ContentScreenState<ExampleContentModel>>
    createExampleContentGraph(ExampleContentUseCases useCases) =>
        (state, event) {
          if (event is AddLike) {
            return DomainGraphEdge(
                sideEffect: SideEffect.change(useCases.addLike));
          } else if (event is RemoveLike) {
            return DomainGraphEdge(
                sideEffect: SideEffect.change(useCases.removeLike));
          }
        };
