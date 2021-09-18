import 'package:applithium_core/domain/content/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/content/states.dart';
import '../graph.dart';
import 'events.dart';

DomainGraph<M, ContentScreenState<M>> createContentGraph<M>(
        ContentUseCases<M> useCases) =>
    (state, event) {
      if (event is WidgetCreatedEvent) {
        DomainGraphEdge(nextState: state.loading());
        return DomainGraphEdge.toState(ContentScreenState.initial());
      }
      if (event is DisplayData) {
        return DomainGraphEdge.toState(state.withData(event.data));
      } else if (event is BaseContentEvents) {
        return event.fold(
            (ReloadRequested) => state.fold(),
            (UpdateRequested) =>,
            (DisplayData) =>
        );
        return state.fold(
            (ContentLoadingState<M> loading) => DomainGraphEdge.withSideEffect(
                SideEffect.init(useCases.load),
                onError: (failure) => loading.withError(failure)),
            (ContentLoadFailedState<M> failure) => event.fold(
                (ReloadRequested reload) =>
                    DomainGraphEdge.toState(failure.reload()),
                (UpdateRequested updateRequested) => DomainGraphEdge.toState(
                    state.withError("Can't update from error state")),
                (DisplayData displayData) => null),
            (DisplayContentState<M> displayContent) => event.fold(
                (ReloadRequested reload) =>
                    DomainGraphEdge.toState(displayContent.reload()),
                (UpdateRequested updateRequested) =>
                    DomainGraphEdge.toState(displayContent.update()),
                (DisplayData displayData) => null),
            (ContentUpdatingState<M> updating) => event.fold(
                (ReloadRequested reload) =>
                    DomainGraphEdge.toState(updating.reload()),
                (UpdateRequested updateRequested) => null,
                (DisplayData displayData) => null));
      }
    };
