
import 'package:applithium_core/presentation/events.dart';

abstract class ExampleContentEvents extends WidgetEvents {
  ExampleContentEvents._(String name) : super(name);

  factory ExampleContentEvents.addLike() => AddLike._();

  factory ExampleContentEvents.removeLike() => RemoveLike._();
}

class AddLike extends ExampleContentEvents {
  AddLike._(): super._("add_like");
}

class RemoveLike extends ExampleContentEvents {
  RemoveLike._(): super._("remove_like");
}

