import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/messaging/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseMessagingService extends MessagingService {
  final AndroidNotificationChannel _androidChannel;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AplRouter router;

  FirebaseMessagingService({
      required this.router,
      String channelId = "applithium_notification_channel",
      String channelTitle = "Applithium based App's channel",
      channelDesc = "This channel is used for important notifications.",
      channelImportance = Importance.high})
      : _androidChannel = AndroidNotificationChannel(
          channelId, // id
          channelTitle, // title
          channelDesc, // description
          importance: channelImportance,
        );

  final _tokenSubj = BehaviorSubject<String>();

  @override
  Stream<String> get tokenStream {
    return _tokenSubj.stream;
  }

  @override
  void startListening() {
    _getTokenImpl();

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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('A new onMessageOpenedApp event was published!');
      router.applyRoute("/message");
    });
  }

  void _getTokenImpl() {
    FirebaseMessaging.instance.getToken(vapidKey: apiKey).then((token) {
      if (token != null) {
        _tokenSubj.add(token);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => _tokenSubj.add(token));
  }

  @override
  void stopListening() {
    // TODO: implement stopListening
  }
}
