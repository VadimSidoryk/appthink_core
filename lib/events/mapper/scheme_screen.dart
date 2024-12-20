import 'package:appthink_core/events/base_event.dart';
import 'package:appthink_core/events/mapper/scheme.dart';
import 'package:appthink_core/events/mapper/scheme_partial.dart';
import 'package:appthink_core/presentation/events.dart';
import 'package:appthink_core/utils/extension.dart';

abstract class ScreenScheme extends EventsHandler {
  static eventScreenOpened(String tag) => "${tag}_screen_open";

  static eventScreenClosed(String tag) => "${tag}_screen_close";

  static const PARAM_SOURCE = "source";
  static const PARAM_NEXT_SCREEN = "next_screen";

  final String targetRoute;

  ScreenScheme(this.targetRoute, {this.routeMapper});

  bool shouldSendOpenEvent = true;

  String getOpenName(String tag) => eventScreenOpened(tag);

  Map<String, Object>? getOpenParams(String? prevScreenTag) =>
      {PARAM_SOURCE: prevScreenTag ?? "undefined"};

  bool shouldSendCloseEvent = true;

  String getCloseName(String tag) => eventScreenClosed(tag);

  Map<String, Object>? getCloseParams(String? nextScreenTag) =>
      {PARAM_NEXT_SCREEN: nextScreenTag ?? "undefined"};

  String Function(String)? routeMapper;

  @override
  bool shouldHandleEvent(AplEvent event) {
    return event is ScreenTransition &&
        (event.to.contains(targetRoute) ||
            event.from?.contains(targetRoute) == true);
  }

  @override
  List<EventData> mapEvent(AplEvent event) {
    event as ScreenTransition;
    final screenTag = routeMapper?.call(targetRoute) ?? targetRoute;
    if (event.to.contains(targetRoute) && shouldSendOpenEvent) {
      final prevScreenTag =
          event.from?.let((it) => routeMapper?.call(it) ?? it);
      return [
        EventData(
            name: getOpenName(screenTag), params: getOpenParams(prevScreenTag))
      ];
    } else if (event.from?.contains(targetRoute) == true &&
        shouldSendCloseEvent) {
      final nextScreenTag = routeMapper?.call(event.to) ?? event.to;
      return [
        EventData(
            name: getCloseName(screenTag),
            params: getCloseParams(nextScreenTag))
      ];
    } else {
      throw "Illegal input event: $event";
    }
  }
}
