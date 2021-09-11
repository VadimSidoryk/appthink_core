import 'package:applithium_core/events/base_event.dart';

class SystemEvent extends AplEvent {
  final AplActionType type;
  final String path;

  SystemEvent._(this.type, this.path);
}

enum AplActionType {
  ROUTE,
  SHOW_MODAL_WINDOW,
  SHOW_BOTTOM_SHEET,
  SHOW_DIALOG,
  SHOW_TOAST,
  SIDE_EFFECT,
  BACK
}

