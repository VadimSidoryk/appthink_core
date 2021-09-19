import 'package:applithium_core/domain/listing/model.dart';
import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/listing/events.dart';
import 'package:applithium_core/presentation/listing/states.dart';

import '../graph.dart';

DomainGraph<M, ListingScreenState<IM, M>>
    createListingGraph<IM, M extends WithList<IM>>(
            ListingUseCases<IM, M> useCases) =>
        (state, event) {
          final loadData = DomainGraphEdge<M, ListingScreenState<IM, M>,
                  ListingScreenState<IM, M>>(
              nextState: ListingScreenState.initial(),
              sideEffect: SideEffect.init(useCases.load),
              resultStateOnError: (error) => state.withError(error));
          if (event is WidgetCreatedEvent) {
            return loadData;
          } else if (event is WidgetShownEvent) {
            state.fold(
                (ListLoadingState _) => null,
                (DisplayListState<IM, M> displayState) => DomainGraphEdge(
                    nextState: displayState.update(),
                    sideEffect: SideEffect.change(useCases.update)),
                (ListPageLoadingState<IM, M> pageLoadingState) =>
                    DomainGraphEdge(
                        nextState: pageLoadingState.update(),
                        sideEffect: SideEffect.change(useCases.update)),
                (ListLoadingFailedState _) => null,
                (ListEmptyState<IM, M> emptyState) => DomainGraphEdge(
                    nextState: emptyState.update(),
                    sideEffect: SideEffect.change(useCases.update)),
                (ListUpdatingState _) => null);
          } else if (event is BaseListEvents) {
            if (event is DisplayData<M>) {
              return DomainGraphEdge(nextState: state.withData((event.data)));
            } else if (event is ScrolledToEnd) {
              return state.fold(
                  (ListLoadingState _) => null,
                  (DisplayListState<IM, M> displayState) => DomainGraphEdge(
                      nextState: displayState.pageLoading(),
                      sideEffect: SideEffect.change(useCases.loadMore)),
                  (ListPageLoadingState _) => null,
                  (ListLoadingFailedState _) => null,
                  (ListEmptyState _) => null,
                  (ListUpdatingState _) => null);
            } else if (event is ReloadList) {
              state.fold(
                  (ListLoadingState _) => null,
                  (DisplayListState _) => loadData,
                  (ListPageLoadingState _) => loadData,
                  (ListLoadingFailedState _) => loadData,
                  (ListEmptyState _) => loadData,
                  (ListUpdatingState _) => loadData);
            }
          }
        };
