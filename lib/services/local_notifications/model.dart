import 'package:appthink_core/config/model.dart';

class LocalNotificationConfig {
  final String channelId;
  final String channelName;
  final String channelDescription;
  final String notificationIcon;

  LocalNotificationConfig(
      {required this.channelId,
      required this.channelName,
      required this.channelDescription,
      required this.notificationIcon});
}

extension LocalNotificationConfigSerializer on AplConfig {
  static const KEY_CHANNEL_ID = "channel_id";
  static const KEY_CHANNEL_NAME = "channel_name";
  static const KEY_CHANNEL_DESCRIPTION = "channel_description";
  static const KEY_NOTIFICATION_ICON = "notification_icon";

  LocalNotificationConfig get notificationConfig {
    return LocalNotificationConfig(
        channelId: getString(KEY_CHANNEL_ID),
        channelName: getString(KEY_CHANNEL_NAME),
        channelDescription: getString(KEY_CHANNEL_DESCRIPTION),
        notificationIcon: getString(KEY_NOTIFICATION_ICON));
  }
}
