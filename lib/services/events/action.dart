class SystemAction {
  final SystemActionType type;
  final String path;

  SystemAction({required this.type, required this.path});
}

enum SystemActionType { ROUTE, SHOW_DIALOG, SHOW_TOAST, ERROR }
