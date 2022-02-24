import 'package:async/async.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/messaging/models/presentation_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef MessageClickListener = Function(int, String);

abstract class Messaging {

  static Messaging mock(Result<void> result) => _MockedMessaging(result);

  NotificationDetails? details;

  final MessagingOptions options;
  final MessageClickListener onMessageClick;

  @protected
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  Messaging({required this.onMessageClick, this.options = const MessagingOptions()}) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
  }

  Future<void> init() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    details = _buildNotificationDetails(options);
  }

  Future<Result<void>> sendPNTo({required String token, required String title, String? body, String? deeplink});

  @protected
  void displayMessage({required int id, String? title, String? body }) {
    final methodName = "displayMessage";
    logMethod(methodName, params: [id, title, body]);
    try {
      flutterLocalNotificationsPlugin.show(
          id,
          title,
          body,
          details
      );
    } catch(e, stacktrace) {
      logError(methodName, e, stacktrace);
    }
  }

  NotificationDetails _buildNotificationDetails(MessagingOptions options) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
        iOS: IOSNotificationDetails(
          presentAlert: options.alert,
          presentBadge: options.badge,
          presentSound: options.sound,
        )
    );
  }
}

class _MockedMessaging extends Messaging {

  final Result<void> result;

  _MockedMessaging(this.result) : super(onMessageClick: (id, text) async {});

  @override
  Future<Result<void>> sendPNTo({required String token, required String title, String? body, String? deeplink}) async {
    return result;
  }

}