import 'dart:async';

import 'package:applithium_core/domain/form/model.dart';
import 'package:applithium_core/domain/form/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/form/events.dart';
import 'package:applithium_core/presentation/form/states.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';

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
    postOn<PostForm>(useCases.post);
  }

  @protected
  void postOn<E extends WidgetEvents>(UseCase<M, bool> poster) {
    sideEffectIml<E>(
        stateFilter: (state) => state is FormDisplayingState<M>,
        waitingStateProvider: (state) => (state as FormDisplayingState<M>).post(),
        effect: SideEffect.post(poster),
        onSuccess: () => (state as FormPostingState<M>).posted(),
        onCancel: () => (state as FormPostingState<M>).failed("Poster returned false"),
        onError: (error) => (state as FormPostingState<M>).failed(error));
  }

}