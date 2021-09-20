import 'package:applithium_core/presentation/base_bloc.dart';

abstract class ExampleContentEvents extends WidgetEvents {
  ExampleContentEvents._(String name) : super(name);
}

class AddLike extends ExampleContentEvents {
  AddLike(): super._("add_like");
}

class RemoveLike extends ExampleContentEvents {
  RemoveLike(): super._("remove_like");
}

