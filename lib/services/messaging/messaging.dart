import 'package:applithium_core/services/local_notifications/abs.dart';
import 'package:async/async.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/messaging/models/presentation_options.dart';
import 'package:flutter/cupertino.dart';

typedef MessageClickListener = Function(int, String);

abstract class Messaging {

  static Messaging mock(Result<void> result) => _MockedMessaging(result);

  final MessagingOptions options;
  final MessageClickListener onMessageClick;
  final LocalNotificationService notificationService;

  Messaging(this.notificationService, {required this.onMessageClick, this.options = const MessagingOptions()});


  Future<Result<void>> sendPNTo({required String token, required String title, String? body, String? deeplink});

  @protected
  void displayMessage({required int id, String? title, String? body}) {
    final methodName = "displayMessage";
    try {
      notificationService.show(
          id: id,
          title: title,
          body: body,
      );
    } catch(e, stacktrace) {
      logError(methodName, e, stacktrace);
    }
  }
}

class _MockedMessaging extends Messaging {

  final Result<void> result;

  _MockedMessaging(this.result) : super(LocalNotificationService.mock, onMessageClick: (_, __){});

  @override
  Future<Result<void>> sendPNTo({required String token, required String title, String? body, String? deeplink}) async {
    return result;
  }

}