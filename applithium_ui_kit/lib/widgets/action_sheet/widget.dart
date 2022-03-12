import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';

import 'resources.dart';

typedef CameraChecker = Future<bool> Function();

class ActionSheetKit {
  final styles = ActionSheetKitStyles();

  BottomSheetAction _actionSheetItem(BuildContext context, String text,
      bool isDestructive, Function()? handler) {
    return BottomSheetAction(
        title: Text(text, style: styles.actionSheetButton(isDestructive)),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          handler?.call();
        });
  }

  Future<dynamic> showPictureActionSheet(BuildContext context,
      {required bool isDeleteAvailable,
      required CameraChecker checkCameras,
      Function()? onGallery,
      Function()? onCamera,
      Function()? onDelete,
      Function()? onCancel}) async {
    final strings = ActionSheetKitStrings();
    var actions = [
      _actionSheetItem(context, strings.fromGallery, false, onGallery),
    ];
    final hasCameras = await checkCameras.call();
    if (hasCameras) {
      actions.insert(
          0, _actionSheetItem(context, strings.takePhoto, false, onCamera));
    }
    if (isDeleteAvailable) {
      actions
          .add(_actionSheetItem(context, strings.deletePhoto, true, onDelete));
    }
    return showAdaptiveActionSheet(
        context: context,
        actions: actions,
        cancelAction: CancelAction(
            title: Text(strings.cancel),
            textStyle: styles.actionSheetCancel,
            onPressed: onCancel));
  }
}