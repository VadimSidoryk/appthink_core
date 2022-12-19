import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/messaging/messaging.dart';
import 'package:applithium_core/services/messaging/models/presentation_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

typedef TokenListener = Future<void> Function(String?);

class FirebaseMessagingImpl extends Messaging {

  final String serverKey;
  final String vapidKey;
  final TokenListener onNewToken;

  FirebaseMessagingImpl(this.serverKey, this.vapidKey,
      {required MessageClickListener onMessageClick,
      required this.onNewToken,
      MessagingOptions options = const MessagingOptions()})
      : super(onMessageClick: onMessageClick, options: options);

  @override
  Future<void> init() async {
    final methodName = "init";
    try {
      final token = await FirebaseMessaging.instance.getToken(
          vapidKey: vapidKey);
      log("onNewToken $token");
      await onNewToken.call(token);
      log("onNewToken called");
      await super.init();

      log("checkPermissions");
      _checkPermissions();

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: options.alert,
        badge: options.badge,
        sound: options.sound,
      );

      log("setup onBackgroundMessage listener");

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      log("setup onMessage listener");

      FirebaseMessaging.onMessage.listen((remoteMessage) {
        log("Foreground callback called remoteMessage = ${jsonEncode(
            remoteMessage.data)}");
        displayMessage(
            id: remoteMessage.hashCode,
            title: "foreground title",
            body: "foreground body");
      });

      log("setup messageOpened listener");

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log("onMessageOpenedApp, message = ${jsonEncode(message.data)}");
        onMessageClick.call(message.hashCode, "/");
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        log("onNewToken $token");
        onNewToken.call(token);
      });
    } catch(e, stacktrace) {
      logError(methodName, e, stacktrace);
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    final methodName = "_firebaseMessagingBackgroundHandler";
    try {
      await Firebase.initializeApp();
      log("app initialized");

      log("calling displayMessage");
      displayMessage(
          id: message.hashCode,
          title: "background title",
          body: "background body");
    } catch(e, stacktrace) {
      logError(methodName, e, stacktrace);
    }
  }

  @override
  Future<Result<void>> sendPNTo(
      {required String token,
      required String title,
      String? body,
      String? deeplink}) async {
    final methodName = "sendPushNotificationTo";
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey'
        },
        body: _constructFCMPayload(token, title, body, deeplink),
      );
      print('FCM request for device sent! response = $response');
      return Result.value(true);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return Result.error(e);
    }
  }

  Future<bool> _checkPermissions() async {
    final methodName = "checkPermission";
    final messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      log("requesting permissions");
      await messaging.requestPermission(
        alert: options.alert,
        announcement: false,
        badge: options.badge,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: options.sound,
      );
      return true;
    } else {
      return true;
    }
  }

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String _constructFCMPayload(
      String token, String title, String? body, String? deepLink) {
    return jsonEncode({
      "to": token,
      "notification": {
        "title": title,
        "body": body,
        "mutable_content": true,
        "sound": "Tri-tone"
      },
      "data": {
        // "url": "<url of media image>",
        "dl": deepLink
      }
    });
  }
}
