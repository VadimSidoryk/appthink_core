import '../events.dart';

abstract class BaseListEvents extends WidgetEvents {
  BaseListEvents._(String name) : super(name);

  factory BaseListEvents.scrolledToEnd() => ListScrolledToEnd._();

  factory BaseListEvents.reload() => ListReloadRequested._();

  factory BaseListEvents.update() => ListUpdateRequested._();
}

class ListScrolledToEnd extends BaseListEvents {
  ListScrolledToEnd._() : super._("scrolled_to_end");
}

class ListUpdateRequested extends BaseListEvents {
  ListUpdateRequested._() : super._("update_list");
}

class ListReloadRequested extends BaseListEvents {
  ListReloadRequested._() : super._("reload_list");
}
