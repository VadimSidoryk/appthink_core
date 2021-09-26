import 'dart:async';

import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/states.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/foundation.dart';

import '../applithium_core.dart';

abstract class BlocWithRepository<M, S extends BaseState<M>>
    extends Bloc<WidgetEvents, S> {
  final AplRepository<M> repository;
  StreamSubscription? _subscription;

  BlocWithRepository(S initialState, {AplRepository<M>? repositoryValue})
      : repository = repositoryValue ?? AplRepository<M>(-1),
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
      required UseCase<void, M> source,
      required FutureOr<S> Function(dynamic) onError}) {
    sideEffectIml<E>(
        waitingStateProvider: (state) => waitingState,
        effect: SideEffect.init(source),
        onError: onError);
  }

  @protected
  void updateOn<E extends WidgetEvents, S1 extends S>(
      {S Function(S1)? waitingStateProvider,
      required UseCase<M, M> updater,
      FutureOr<S> Function(dynamic)? onError,
      FutureOr<S> Function()? onCancel}) {
    final initialState = state;
    sideEffectIml<E>(
        stateFilter: (state) => state is S1,
        waitingStateProvider: waitingStateProvider != null
            ? (state) => waitingStateProvider.call(state as S1)
            : null,
        effect: SideEffect.change(updater),
        onError: onError ?? (error) => initialState,
        onCancel: onCancel ?? () => initialState);
  }

  @protected
  void sideEffectIml<E extends WidgetEvents>(
      {bool Function(S)? stateFilter,
      S Function(S)? waitingStateProvider,
      required SideEffect<M> effect,
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

      final effectResult = await effect.apply(repository);
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
