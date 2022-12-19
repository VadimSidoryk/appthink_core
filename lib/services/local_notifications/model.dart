import 'package:applithium_core/config/model.dart';

class LocalNotificationConfig {
  final String channelId;
  final String channelName;
  final String channelDescription;

  LocalNotificationConfig(
      {required this.channelId,
      required this.channelName,
      required this.channelDescription});
}


extension LocalNotificationConfigSerializer on AplConfig {
  static const KEY_CHANNEL_ID = "channel_id";
  static const KEY_CHANNEL_NAME = "channel_name";
  static const KEY_CHANNEL_DESCRIPTION = "channel_description";

  static const _DEFAULT_CHANNEL_ID = "channel.acc";
  static const _DEFAULT_CHANNEL_NAME = "accumulation_reminder";
  static const _DEFAULT_CHANNEL_DESCRIPTION =
      "Remind user to add money to accumulation";

  LocalNotificationConfig get notificationConfig {
    return LocalNotificationConfig(
        channelId: getString(KEY_CHANNEL_ID) ?? _DEFAULT_CHANNEL_ID,
        channelName: getString(KEY_CHANNEL_NAME) ?? _DEFAULT_CHANNEL_NAME,
        channelDescription: getString(KEY_CHANNEL_DESCRIPTION) ?? _DEFAULT_CHANNEL_DESCRIPTION);
  }
}