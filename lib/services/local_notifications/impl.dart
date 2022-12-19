import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/utils/extension.dart';
import 'package:async/async.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'abs.dart';
import 'model.dart';

class LocalNotificationServiceImpl extends LocalNotificationService {
  late LocalNotificationConfig? _config;
  late FlutterLocalNotificationsPlugin plugin;
  final Function(String?)? onNotificationClick;

  LocalNotificationServiceImpl({AplConfig? config, this.onNotificationClick}) {
    _init(config);
  }

  static final _plugin = FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  NotificationDetails? get notificationDetails {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            _config?.channelId ?? "default-channel-id",
            _config?.channelName ?? "default-channel-name",
            channelDescription:
            _config?.channelDescription ?? "default-channel-description"));
  }

  Future<void> _init(AplConfig? appConfig) async {
    _config = appConfig?.notificationConfig;
    await _initPlugin();
    log("injectToApp");
    final payload = await _getInitialPayload(_plugin);
    if (payload != null) {
      onNotificationClick?.call(payload);
    }
  }

  Future<void> _initPlugin() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("ic_soulmates");

    final darwinInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: darwinInitializationSettings);
    await _plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _selectNotification);

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<String?> _getInitialPayload(
      FlutterLocalNotificationsPlugin plugin) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await plugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      return notificationAppLaunchDetails?.notificationResponse?.payload;
    } else {
      return null;
    }
  }

  @override
  Future<Result<void>> show({required int id,
    String? title,
    String? body,
    String? deeplink,
    DateTime? when,
    bool alert = true,
    bool badge = true,
    bool sound = true}) =>
      safeCall(() async {
        final notificationDetails =
        _buildNotificationDetails(alert, badge, sound);
        if (when == null) {
          _plugin.show(id, title, body, notificationDetails, payload: deeplink);
        } else {
          final scheduledDate = tz.TZDateTime.fromMillisecondsSinceEpoch(
              tz.local, when.millisecondsSinceEpoch);
          _plugin.zonedSchedule(
              id, title, body, scheduledDate, notificationDetails,
              uiLocalNotificationDateInterpretation:  UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true);
        }
      });

  Future<dynamic> _selectNotification(NotificationResponse details) async {
    log("selectNotification, service = $_plugin");
    onNotificationClick?.call(details.payload);
  }

  NotificationDetails _buildNotificationDetails(bool alert, bool badge,
      bool sound) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: alert,
          presentBadge: badge,
          presentSound: sound,
        ));
  }
}


