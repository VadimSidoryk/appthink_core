import 'package:applithium_core/utils/extension.dart';
import 'package:async/async.dart';

abstract class LocalNotificationService {
  static final LocalNotificationService mock =
      _MockedLocalNotificationService();

  Future<Result<void>> show(
      {required int id,
      String? title,
      String? body,
      String? deeplink,
      DateTime? when,
      bool alert = true,
      bool badge = true,
      bool sound = true});
}

class _MockedLocalNotificationService extends LocalNotificationService {
  @override
  Future<Result<void>> show(
          {required int id,
          String? title,
          String? body,
          String? deeplink,
          DateTime? when,
          bool alert = true,
          bool badge = true,
          bool sound = true}) =>
      safeCall(() {});
}
