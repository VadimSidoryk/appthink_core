import 'package:applithium_core/presentation/base_';
import 'package:applithium_core/presentation/content/events';
import '../.domain/use_cases.dart';
import '../.domain/model.dart';

DomainGraph<ContentScreenModel, ContentState<ContentScreenModel>>
    createContentGraph(ContentScreenUseCases useCases) =>
        createContentGraph(testLoad).plus((state, event) {
          if (event is ContentScreenEvents) {
            return event.fold(
                (likeAdded) => DomainGraphEdge(
                    sideEffect: SideEffect.change(useCases.addLike)),
                (likeRemoved) => DomainGraphEdge(
                    sideEffect: SideEffect.change(useCases.removeLike)),
                (forceUpdate) => DomainGraphEdge(
                    newState: ContentLoading(),
                    sideEffect: SideEffect.change(useCases.load)));
          }
        });
