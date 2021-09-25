import 'package:applithium_core/domain/form/model.dart';
import 'package:applithium_core/domain/form/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/form/events.dart';
import 'package:applithium_core/presentation/form/states.dart';

import '../events.dart';

class FormBloc<M extends BaseFormModel> extends BlocWithRepository<M, FormScreenState<M>> {

  final FormUseCases<M> useCases;

  FormBloc(this.useCases, {AplRepository<M>? repository}) : super(FormScreenState.initial(), repositoryValue: repository) {
    loadOn<WidgetCreatedEvent>(
        waitingState: FormScreenState.initial(),
        source: useCases.load,
        onError: (error) => state.withError(error));
    updateOn<WidgetShownEvent, FormDisplayingState<M>>(
        waitingStateProvider: (state) => state.update(),
        updater: useCases.update);
    loadOn<FormReloadRequested>(
        waitingState: FormScreenState.initial(),
        source: useCases.load,
        onError: (error) => state.withError(error));
    updateOn<FormUpdateRequested, FormDisplayingState<M>>(
        waitingStateProvider: (state) => state.update(),
        updater: useCases.update);
    postOn<PostForm, FormDisplayingState<M>, FormPostingState<M>>(
      waitingStateProvider: (state) => state.post(),
      poster: useCases.post,
      onSuccess: (state) => state.posted(),
      onError: (error) => state.withError(error)
    );
  }

}