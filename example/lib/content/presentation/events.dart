import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/unions/union_2.dart';

abstract class ExampleContentEvents extends WidgetEvents with Union2<AddLike, RemoveLike> {
  ExampleContentEvents._(String name) : super(name);
}

class AddLike extends ExampleContentEvents {
  AddLike(): super._("add_like");
}

class RemoveLike extends ExampleContentEvents {
  RemoveLike(): super._("remove_like");
}

