import 'package:applithium_core/domain/listing/model.dart';
import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/listing/events.dart';
import 'package:applithium_core/presentation/listing/states.dart';

import '../graph.dart';

DomainGraph<M, ListingScreenState<IM, M>>
    createListingGraph<IM, M extends WithList<IM>>(ListingUseCases useCases) =>
        (state, event) {
          if (event is DisplayData<M>) {
            return DomainGraphEdge.toState(state.withData(event.data));
          } else if(event is BaseListEvents) {
            state.fold(
                (ListLoadingState loadingState) => DomainGraphEdge.withSideEffect(
                    SideEffect.init(useCases.load),
                    onError: (error) => loadingState.withError(error)),
                (DisplayListState displayState) => event.fold(
                    (DisplayData displayEvent) => null,
                    (ScrolledToEnd scrolledEvent) =>
                        DomainGraphEdge.toState(displayState.pageLoading()),
                    (ReloadList reloadEvent) =>
                        DomainGraphEdge.toState(displayState.reload())),
                (ListPageLoadingState loadingPageState) =>
                    DomainGraphEdge.withSideEffect(SideEffect.change(useCases.loadMore),
                        onCancel: () => loadingPageState.endReached(),
                        onError: (error) => loadingPageState.withError(error)),
                (ListLoadingFailedState failed) => event.fold(
                    (DisplayData displayEvent) => null,
                    (ScrolledToEnd scrolledEvent) => null,
                    (ReloadList reloadEvent) =>
                        DomainGraphEdge.toState(failed.reload())),
                (EndReachedState endReached) => event.fold(
                    (DisplayData displayEvent) => null,
                    (ScrolledToEnd scrolledEvent) => DomainGraphEdge.toState(endReached.pageLoading()),
                    (ReloadList reloadEvent) => DomainGraphEdge.toState(endReached.reload())));
          }
        };
