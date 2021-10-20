import 'dart:async';

import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/domain/use_case.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/states.dart';
import 'package:flutter/foundation.dart';

import '../applithium_core.dart';

abstract class BlocWithRepository<M, S extends BaseState<M>>
    extends Bloc<WidgetEvents, S> {
  final Repository<M> repository;
  StreamSubscription? _subscription;

  BlocWithRepository(S initialState, {Repository<M>? repositoryValue})
      : repository = repositoryValue ?? Repository<M>(-1),
        super(initialState) {
    _subscription = this.repository.updatesStream.listen((data) {
      add(BaseWidgetEvents.repositoryUpdated(data));
    });
    on<RepositoryUpdatedEvent>(
            (event, emit) => emit(state.withData(event.data) as S));
  }

  @protected
  void loadOn<E extends WidgetEvents>(
      {required S waitingState,
        required UseCase<void, M> Function(E) loadingUCProvider,
        required FutureOr<S> Function(dynamic) onError}) {
    sideEffectIml<E>(
        waitingStateProvider: (state) => waitingState,
        effectProvider: (event) => SideEffect.load(loadingUCProvider.call(event)),
        onError: onError);
  }

  @protected
  void updateOn<E extends WidgetEvents>(
      {required S waitingState,
        required UseCase<void, M> Function(E) updatingUCProvider,
        required FutureOr<S> Function(dynamic) onError}) {
    sideEffectIml<E>(
        waitingStateProvider: (state) => waitingState,
        effectProvider: (event) => SideEffect.update(updatingUCProvider.call(event)),
        onError: onError);
  }

  @protected
  void changeOn<E extends WidgetEvents, S1 extends S>(
      {S Function(S1)? waitingStateProvider,
        required UseCase<M, M> Function(E) changingUCProvider,
        FutureOr<S> Function(dynamic)? onError,
        FutureOr<S> Function()? onCancel}) {
    final initialState = state;
    sideEffectIml<E>(
        stateFilter: (state) => state is S1,
        waitingStateProvider: waitingStateProvider != null
            ? (state) => waitingStateProvider.call(state as S1)
            : null,
        effectProvider: (event) => SideEffect.change(changingUCProvider.call(event)),
        onError: onError ?? (error) => initialState,
        onCancel: onCancel ?? () => initialState);
  }

  @protected
  void sideEffectIml<E extends WidgetEvents>(
      {bool Function(S)? stateFilter,
        S Function(S)? waitingStateProvider,
        required SideEffect<M> Function(E) effectProvider,
        FutureOr<S> Function()? onSuccess,
        FutureOr<S> Function()? onCancel,
        FutureOr<S> Function(dynamic)? onError}) {
    on<E>((event, emit) async {
      if (stateFilter != null && !stateFilter.call(state)) {
        return;
      }

      if (waitingStateProvider != null) {
        emit(waitingStateProvider.call(state));
      }

      final effectResult = await effectProvider(event).apply(repository);
      if (effectResult.value != null) {
        if (effectResult.value! && onSuccess != null) {
          final resultState = await onSuccess.call();
          emit(resultState);
        } else if (!effectResult.value! && onCancel != null) {
          final cancelState = await onCancel.call();
          emit(cancelState);
        }
      } else {
        if (onError != null) {
          final errorState =
          await onError.call(effectResult.exception ?? "Unknown exception");
          emit(errorState);
        }
      }
    });
  }

  @override
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}
