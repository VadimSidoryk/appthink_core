import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/content/bloc.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:flutter/cupertino.dart';
import 'package:applithium_core/scopes/extensions.dart';

import 'model.dart';

abstract class ContentScreenEvents extends BaseContentEvents {
  ContentScreenEvents(String name): super(name);

  factory ContentScreenEvents.likeAdded() => _LikeAdded();

  factory ContentScreenEvents.likeRemoved() => _LikeRemoved();

  factory ContentScreenEvents.forceUpdate() => _ForceUpdate();
}

class _LikeAdded extends ContentScreenEvents {
  _LikeAdded(): super("like");
}

class _LikeRemoved extends ContentScreenEvents {
  _LikeRemoved(): super("dislike");
}

class _ForceUpdate extends ContentScreenEvents {
  _ForceUpdate(): super("force_update");
}

final testLoad = value(value: ContentViewModel("sample title", "sample description", 2), delayMillis: 3000);

Future<ContentViewModel> addLike(ContentViewModel model) async => model.copyWith(likes: model.likes + 1);

Future<ContentViewModel> removeLike(ContentViewModel model) async => model.copyWith(likes: model.likes - 1);

final DomainGraph<ContentViewModel, ContentState<ContentViewModel>> contentGraph = (state, event) {
  if(event is _LikeAdded) {
    return DomainGraphEdge(
     sideEffect: addLike
    );
  } else if(event is _LikeRemoved) {
    return DomainGraphEdge(
     sideEffect: removeLike
    );
  } else if(event is _ForceUpdate) {
    return DomainGraphEdge(
      newState: ContentLoading(),
      sideEffect: testLoad
    );
  }
};

ContentBloc<ContentViewModel> provideContentBloc(BuildContext context, Presenters presenters) {
  return ContentBloc(
    repository: context.get(),
    presenters: presenters,
    load: testLoad,
    customGraph: contentGraph
  );
}



