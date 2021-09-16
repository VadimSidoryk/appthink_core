import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/unions/union_3.dart';


abstract class ContentScreenEvents extends WidgetEvents
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