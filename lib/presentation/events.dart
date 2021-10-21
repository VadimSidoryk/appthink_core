import 'package:applithium_core/events/base_event.dart';
import 'package:flutter/widgets.dart';

abstract class WidgetEvents extends AplEvent {
  WidgetEvents(String name, [Map<String, Object>? params])
      : super(name, params);
}

class BaseWidgetEvents<M> extends WidgetEvents {
  BaseWidgetEvents._(String name, [Map<String, Object>? params])
      : super(name, params);

  factory BaseWidgetEvents.widgetCreated(Widget widget) =>
      WidgetCreatedEvent._(widget);

  factory BaseWidgetEvents.widgetShown(String name) => WidgetShownEvent._(name);

  factory BaseWidgetEvents.repositoryUpdated(M data) =>
      RepositoryUpdatedEvent._(data);
}

class WidgetCreatedEvent<M> extends BaseWidgetEvents<M> {
  final Widget widget;

  WidgetCreatedEvent._(this.widget)
      : super._("widget_created", {"screen_name": widget.toString()});
}

class WidgetShownEvent<M> extends BaseWidgetEvents<M> {
  final String screenName;

  WidgetShownEvent._(this.screenName)
      : super._("widget_shown", {"screen_name": screenName});
}

class RepositoryUpdatedEvent<M> extends BaseWidgetEvents<M> {
  final M data;

  RepositoryUpdatedEvent._(this.data)
      : super._("repository_updated", {"data": data.toString()});
}