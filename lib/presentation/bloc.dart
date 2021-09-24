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
      add(RepositoryUpdatedEvent._(data));
    });
  }

  @protected
  void loadOn<E extends WidgetEvents>(
      {required S waitingState,
      required UseCase<void, M> source,
      required FutureOr<S> Function(dynamic) onError}) {
    _withSideEffectIml<E>(
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
    _withSideEffectIml(
        stateFilter: (state) => state is S1,
        waitingStateProvider: waitingStateProvider != null
            ? (state) => waitingStateProvider.call(state as S1)
            : null,
        effect: SideEffect.change(updater),
        onError: onError ?? (error) => initialState,
        onCancel: onCancel ?? () => initialState);
  }

  @protected
  void postOn<E extends WidgetEvents>(
      {required S waitingState,
      required UseCase<M, void> poster,
      required FutureOr<S> Function(bool) onResult,
      required FutureOr<S> Function(dynamic) onError}) {
    _withSideEffectIml(
        waitingStateProvider: (state) => waitingState,
        effect: SideEffect.post(poster),
        onSuccess: () => onResult.call(true),
        onCancel: () => onResult.call(false),
        onError: onError);
  }

  void _withSideEffectIml<E extends WidgetEvents>(
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
      effectResult.forEach((value) async {
        if (value) {
          if (onSuccess != null) {
            emit(await onSuccess.call());
          }
        } else {
          if (onCancel != null) {
            emit(await onCancel.call());
          }
        }
      }, (error) async {
        if (onError != null) {
          emit(await onError.call(error));
        }
      });
    });
  }

  @override
  Future<void> close() async {
    await super.close();
    return _subscription?.cancel();
  }
}
