class AplAction {
  final AplActionType type;
  final String path;

  AplAction._(this.type, this.path);
}

enum AplActionType {
  ROUTE,
  SHOW_MODAL_WINDOW,
  SHOW_BOTTOM_SHEET,
  SHOW_DIALOG,
  SHOW_TOAST,
  BACK
}

extension RouteTypeFactory on String {
  AplActionType toRouteType() {
    switch (this) {
      case "route":
        return AplActionType.ROUTE;
      case "modal":
        return AplActionType.SHOW_MODAL_WINDOW;
      case "sheet":
        return AplActionType.SHOW_BOTTOM_SHEET;
      case "dialog":
        return AplActionType.SHOW_DIALOG;
      case "toast":
        return AplActionType.SHOW_TOAST;
      default:
        return AplActionType.BACK;
    }
  }
}
