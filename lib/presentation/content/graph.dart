import 'package:applithium_core/domain/content/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/content/states.dart';
import '../graph.dart';
import 'events.dart';

DomainGraph<M, ContentScreenState<M>> createContentGraph<M>(
        ContentUseCases<M> useCases) =>
    (state, event) {
      final loadData =
          DomainGraphEdge<M, ContentScreenState<M>, ContentScreenState<M>>(
              nextState: ContentScreenState.initial(),
              sideEffect: SideEffect.init(useCases.load),
              resultStateOnError: (error) => state.withError(error));
      if (event is WidgetCreatedEvent) {
        return loadData;
      } else if (event is WidgetShownEvent) {
        if (state is DisplayContentState) {
          return DomainGraphEdge(
              nextState: (state as DisplayContentState<M>).update(),
              sideEffect: SideEffect.change(useCases.update));
        }
      } else if (event is DisplayData) {
        return DomainGraphEdge(nextState: state.withData(event.data));
      } else if (event is BaseContentEvents) {
        if (event is ReloadRequested) {
          return state.fold(
              (ContentLoadingState<M> _) => null,
              (ContentLoadFailedState<M> _) => loadData,
              (DisplayContentState<M> _) => loadData,
              (ContentUpdatingState<M> _) => loadData);
        } else if (event is UpdateRequested) {
          return state.fold(
              (ContentLoadingState<M> _) => null,
              (ContentLoadFailedState<M> _) => null,
              (DisplayContentState<M> displayState) => DomainGraphEdge(
                  nextState: displayState.update(),
                  sideEffect: SideEffect.change(useCases.update)),
              (ContentUpdatingState<M> _) => null);
        }
      }
    };
