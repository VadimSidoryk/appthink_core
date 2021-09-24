import '../events.dart';

abstract class BaseContentEvents extends WidgetEvents {
  BaseContentEvents._(String name) : super(name);

  factory BaseContentEvents.reload() => ContentReloadRequested._();

  factory BaseContentEvents.update() => ContentUpdateRequested._();
}

class ContentReloadRequested extends BaseContentEvents {
  ContentReloadRequested._() : super._("content_reload");
}

class ContentUpdateRequested extends BaseContentEvents {
  ContentUpdateRequested._() : super._("content_update");
}


