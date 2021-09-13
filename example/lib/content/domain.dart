import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/content/domain.dart';
import 'package:applithium_core/unions/union_3.dart';
import 'package:applithium_core/usecases/mocks/value.dart';

import 'model.dart';

abstract class ContentScreenEvents extends BaseContentEvents
    with Union3<_LikeAdded, _LikeRemoved, _ForceUpdate> {
  ContentScreenEvents(String name) : super(name);

  factory ContentScreenEvents.likeAdded() => _LikeAdded();

  factory ContentScreenEvents.likeRemoved() => _LikeRemoved();

  factory ContentScreenEvents.forceUpdate() => _ForceUpdate();
}

class _LikeAdded extends ContentScreenEvents {
  _LikeAdded() : super("like");
}

class _LikeRemoved extends ContentScreenEvents {
  _LikeRemoved() : super("dislike");
}

class _ForceUpdate extends ContentScreenEvents {
  _ForceUpdate() : super("force_update");
}

final testLoad = value(
    value: ContentViewModel("sample title", "sample description", 2),
    delayMillis: 3000);

Future<ContentViewModel> addLike(ContentViewModel model) async =>
    model.copyWith(likes: model.likes + 1);

Future<ContentViewModel> removeLike(ContentViewModel model) async =>
    model.copyWith(likes: model.likes - 1);

final DomainGraph<ContentViewModel, ContentState<ContentViewModel>>
    contentGraph = createContentGraph(testLoad).plus((state, event) {
  if (event is ContentScreenEvents) {
    return event.fold(
        (likeAdded) => DomainGraphEdge(sideEffect: SideEffect.change(addLike)),
        (likeRemoved) =>
            DomainGraphEdge(sideEffect: SideEffect.change(removeLike)),
        (forceUpdate) => DomainGraphEdge(
            newState: ContentLoading(),
            sideEffect: SideEffect.change(testLoad)));
  }
});
