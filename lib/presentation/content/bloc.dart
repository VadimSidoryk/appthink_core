import 'package:applithium_core/domain/content/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/content/events.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core/presentation/events.dart';

class ContentBloc<M> extends BlocWithRepository<M, ContentScreenState<M>> {
  final ContentUseCases<M> useCases;

  ContentBloc(this.useCases, {AplRepository<M>? repository})
      : super(ContentScreenState.initial(), repositoryValue: repository) {
    loadOn<WidgetCreatedEvent>(
        waitingState: ContentScreenState.initial(),
        sourceProvider: (event) => useCases.load,
        onError: (error) => state.withError(error));
    updateOn<WidgetShownEvent, ContentDisplayingState<M>>(
        waitingStateProvider: (state) => state.update(),
        updaterProvider: (event) => useCases.update);
    loadOn<ContentReloadRequested>(
        waitingState: ContentScreenState.initial(),
        sourceProvider: (event) => useCases.load,
        onError: (error) => state.withError(error));
    updateOn<ContentUpdateRequested, ContentDisplayingState<M>>(
        waitingStateProvider: (state) => state.update(),
        updaterProvider: (event) => useCases.update);
  }
}
