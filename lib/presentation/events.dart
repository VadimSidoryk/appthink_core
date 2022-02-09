import 'package:applithium_core/events/base_event.dart';
import 'package:flutter/widgets.dart';

abstract class WidgetEvents extends AplEvent {
  const WidgetEvents(String name, [Map<String, Object>? params, bool shouldBeTracked = true])
      : super(name, params, shouldBeTracked);
}

class BaseWidgetEvents<M> extends WidgetEvents {
  BaseWidgetEvents._(String name, [Map<String, Object>? params, bool shouldBeTracked = true])
      : super(name, params, shouldBeTracked);

  factory BaseWidgetEvents.widgetCreated(String name, Type type) =>
      WidgetCreatedEvent._(name, type);

  factory BaseWidgetEvents.widgetShown(String name) => WidgetShownEvent._(name);

  factory BaseWidgetEvents.internalStateChanged(M data) =>
      InternalStateChanged._(data);
}

class WidgetCreatedEvent<M> extends BaseWidgetEvents<M> {
  final String name;
  final Type type;

  WidgetCreatedEvent._(this.name, this.type)
      : super._("widget_created", {"screen_name": name, "screen_type": type});
}

class WidgetShownEvent<M> extends BaseWidgetEvents<M> {
  final String screenName;

  WidgetShownEvent._(this.screenName)
      : super._("widget_shown", {"screen_name": screenName});
}

class InternalStateChanged<M> extends BaseWidgetEvents<M> {
  final M data;

  InternalStateChanged._(this.data)
      : super._("internal_state_changed", {"data": data.toString()}, false);
}