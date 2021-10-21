class PromoAction {
  final SystemActionType type;
  final String path;

  PromoAction({required this.type, required this.path});
}

enum SystemActionType { ROUTE, SHOW_DIALOG, SHOW_TOAST, ERROR }
