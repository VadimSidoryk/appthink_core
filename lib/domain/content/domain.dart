import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/unions/union_4.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';

const STATE_CONTENT_INITIAL = "initial";
const STATE_CONTENT_LOADING = "loading";
const STATE_CONTENT_ERROR = "failed";
const STATE_CONTENT_UPDATING = "updating";
const STATE_CONTENT_LOADED = "loaded";

abstract class BaseContentEvents extends WidgetEvents {
  BaseContentEvents(String name) : super(name);
}

class UpdateRequested extends BaseContentEvents {
  UpdateRequested() : super("screen_update");
}

class DisplayData<M> extends BaseContentEvents {
  final M data;

  DisplayData(this.data) : super("data_updated");
}

abstract class ContentScreenState<M> extends BaseState<M>
    with Union4<ContentLoading<M>, ContentLoadFailed<M>, DisplayContent<M>, ContentUpdating<M>> {
  ContentScreenState._(String tag) : super(tag);

  factory ContentScreenState.initial() => ContentLoading._();

  @override
  ContentScreenState<M> withError(dynamic error) => ContentLoadFailed._(error);
}

class ContentLoading<M> extends ContentScreenState<M> {
  ContentLoading._() : super._(STATE_CONTENT_LOADING);

  ContentScreenState<M> withData(M data) => DisplayContent._(data);
}

class ContentLoadFailed<M> extends ContentScreenState<M> {
  final dynamic error;

  ContentLoadFailed._(this.error) : super._(STATE_CONTENT_ERROR);
}

abstract class HasContent<M> extends ContentScreenState<M> {
  final M data;
  final bool isUpdating;

  ContentScreenState<M> forceUpdate() => ContentLoading._();

  HasContent._({required this.data, required this.isUpdating, required String tag}): super._(tag);
}

class DisplayContent<M> extends HasContent<M> {
  DisplayContent._(M data) : super._(data: data, isUpdating: false, tag: STATE_CONTENT_LOADED);

  ContentScreenState<M> update() => ContentUpdating._(this.data);
}

class ContentUpdating<M> extends HasContent<M> {
  ContentUpdating._(M data): super._(data: data, isUpdating: true, tag: STATE_CONTENT_UPDATING);
  ContentScreenState<M> updated(M data) => DisplayContent._(data);
}

abstract class ContentUseCases<M> {
  Future<M> load();
  Future<M> update();
}


DomainGraph<M, ContentScreenState<M>> createContentGraph<M>(ContentUseCases<M> useCases) => (state, event) {
  if(event is ModelUpdated) {
    return DomainGraphEdge(nextStateProvider: ());
  }
      return state.fold(
          (loading) => DomainGraphEdge(
              sideEffect: SideEffect.init(load),
              nextStateProvider: (result) => result.fold(
                  (data) => loading.withData(data),
                  (failure) => loading.withError(failure))),
          (displayContent) => event,
          (failure) => null);
    };
