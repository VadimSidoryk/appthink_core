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
        source: useCases.load,
        onError: (error) => state.withError(error));
    updateOn<WidgetShownEvent, DisplayContentState<M>>(
        waitingStateProvider: (state) => state.update(),
        updater: useCases.update);
    loadOn<ContentReloadRequested>(
        waitingState: ContentScreenState.initial(),
        source: useCases.load,
        onError: (error) => state.withError(error));
    updateOn<ContentUpdateRequested, DisplayContentState<M>>(
        waitingStateProvider: (state) => state.update(),
        updater: useCases.update);
  }
}
