import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/content/bloc.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:applithium_core_example/test/model.dart';

final testLoad = value(value: TestViewModel("sample title", "sample description", 2), delayMillis: 3000);

Future<TestViewModel> addLike(TestViewModel model) async => model.copyWith(likes: model.likes + 1);

Future<TestViewModel> removeLike(TestViewModel model) async => model.copyWith(likes: model.likes - 1);

final DomainGraph<TestViewModel, ContentState<TestViewModel>> testGraph = (state, event) {
  if(event is _LikeAdded) {
    return DomainGraphEdge(
     sideEffect: addLike
    );
  } else if(event is _LikeRemoved) {
    return DomainGraphEdge(
     sideEffect: removeLike
    );
  }
};

abstract class TestScreenEvents extends BaseContentEvents {
  TestScreenEvents(String name): super(name);

  factory TestScreenEvents.likeAdded() => _LikeAdded();

  factory TestScreenEvents.likeRemoved() => _LikeRemoved();

}

class _LikeAdded extends TestScreenEvents {
  _LikeAdded(): super("like");
}

class _LikeRemoved extends TestScreenEvents {
  _LikeRemoved(): super("dislike");
}

