import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'config.dart';

class LocalNotificationService  {
  late LocalNotificationConfig _config;
  late FlutterLocalNotificationsPlugin plugin;
  final Function(String?)? onNotificationClick;

  LocalNotificationService(AplConfig config, {this.onNotificationClick}) {
    _init(config);
  }

  NotificationDetails? get notificationDetails {
    return NotificationDetails(
        android: AndroidNotificationDetails(_config.channelId,
            _config.channelName, _config.channelDescription));
  }

  Future<void> _init(AplConfig appConfig) async {
    _config = appConfig.notificationConfig;
    final plugin = await _initPlugin();
    log("injectToApp");
    final payload = await _getInitialPayload(plugin);
    if (payload != null) {
      onNotificationClick?.call(payload);
    }
  }

  Future<FlutterLocalNotificationsPlugin> _initPlugin() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _selectNotification);
    return flutterLocalNotificationsPlugin;
  }

  Future<String?> _getInitialPayload(
      FlutterLocalNotificationsPlugin plugin) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await plugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      return notificationAppLaunchDetails!.payload;
    } else {
      return null;
    }
  }

  Future<dynamic> _selectNotification(String? payload) async {
    log("selectNotification, service = $plugin");
    onNotificationClick?.call(payload);
  }
}

extension LocalNotificationConfigSerializer on AplConfig {
  static const _DEFAULT_CHANNEL_ID = "channel.acc";
  static const _DEFAULT_CHANNEL_NAME = "accumulation_reminder";
  static const _DEFAULT_CHANNEL_DESCRIPTION =
      "Remind user to add money to accumulation";

  LocalNotificationConfig get notificationConfig {
    return LocalNotificationConfig(
        channelId: _DEFAULT_CHANNEL_ID,
        channelName: _DEFAULT_CHANNEL_NAME,
        channelDescription: _DEFAULT_CHANNEL_DESCRIPTION);
  }
}
