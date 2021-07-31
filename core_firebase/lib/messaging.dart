import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/services/messaging/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:applithium_core/logs/extension.dart';

class FirebaseMessagingService extends MessagingService {
  final AndroidNotificationChannel _androidChannel;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AplRouter _router;

  FirebaseMessagingService(this._router,
      {String channelId = "applithium_notification_channel",
      String channelTitle = "Applithium based App's channel",
      channelDesc = "This channel is used for important notifications.",
      channelImportance = Importance.high})
      : _androidChannel = AndroidNotificationChannel(
          channelId, // id
          channelTitle, // title
          channelDesc, // description
          importance: channelImportance,
        );

  @override
  void startListening() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                _androidChannel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      _router.applyRoute("/message");
    });
  }

  @override
  void stopListening() {
    // TODO: implement stopListening
  }
}
