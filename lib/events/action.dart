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
  REQUEST_GET,
  DOMAIN_LEVEL_EVENT,
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
      case "get":
        return AplActionType.REQUEST_GET;
      case "domain":
        return AplActionType.DOMAIN_LEVEL_EVENT;
      default:
        return AplActionType.BACK;
    }
  }
}
