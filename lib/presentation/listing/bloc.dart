import 'package:applithium_core/domain/listing/model.dart';
import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/listing/events.dart';
import 'package:applithium_core/presentation/listing/states.dart';

import '../events.dart';

class ListingBloc<IM, M extends BaseListModel<IM>> extends BlocWithRepository<M, ListingScreenState<IM, M>> {
  final ListingUseCases<IM, M> useCases;

  ListingBloc(this.useCases, {AplRepository<M>? repository}): super(ListingScreenState.initial(), repositoryValue: repository) {
    loadOn<WidgetCreatedEvent>(
        waitingState: ListingScreenState.initial(),
        loadingUCProvider: (event) => useCases.load,
        onError: (error) => state.withError(error));
    changeOn<WidgetShownEvent, ListDisplayingState<IM, M>>(
        waitingStateProvider: (state) => state.update(),
        changingUCProvider: (event) => useCases.update);
    loadOn<ListReloadRequested>(
        waitingState: ListingScreenState.initial(),
        loadingUCProvider: (event) => useCases.load,
        onError: (error) => state.withError(error));
    changeOn<ListUpdateRequested, ListDisplayingState<IM, M>>(
        waitingStateProvider: (state) => state.update(),
        changingUCProvider: (event) => useCases.update);
    changeOn<ListScrolledToEnd, ListDisplayingState<IM, M>>(
      waitingStateProvider: (state) => state.pageLoading(),
        changingUCProvider: (event) => useCases.loadMore
    );
  }
}