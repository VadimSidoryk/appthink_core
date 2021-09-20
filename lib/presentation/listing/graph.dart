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
          if(event is RepositoryUpdatedEvent<M>) {
            return DomainGraphEdge(nextState: state.withData(event.data));
          }

          final loadData = DomainGraphEdge<M, ListingScreenState<IM, M>,
                  ListingScreenState<IM, M>>(
              nextState: ListingScreenState.initial(),
              sideEffect: SideEffect.init(useCases.load),
              resultStateOnError: (error) => state.withError(error));
          if (event is WidgetCreatedEvent) {
            return loadData;
          } else if (event is WidgetShownEvent) {
            if(state is DisplayListState<IM, M>) {
              return DomainGraphEdge(
                  nextState: state.update(),
                  sideEffect: SideEffect.change(useCases.update));
            } else if(state is ListPageLoadingState<IM, M>) {
              return DomainGraphEdge(
                  nextState: state.update(),
                  sideEffect: SideEffect.change(useCases.update));
            } else if(state is ListEmptyState<IM, M>) {
              return DomainGraphEdge(
                  nextState: state.update(),
                  sideEffect: SideEffect.change(useCases.update));
            } else {
              return null;
            }
          } else if (event is BaseListEvents) {
            if (event is DisplayData<M>) {
              return DomainGraphEdge(nextState: state.withData((event.data)));
            } else if (event is ScrolledToEnd) {
              if(state is DisplayListState<IM, M>) {
                return DomainGraphEdge(
                    nextState: state.pageLoading(),
                    sideEffect: SideEffect.change(useCases.loadMore));
              } else {
                return null;
              }
            } else if (event is ReloadList) {
              if(state is ListLoadingState) {
                return null;
              } else {
                return loadData;
              }
            }
          }
        };
