import 'dart:convert';

import 'package:applithium_core/services/rate_us/config.dart';
import 'package:applithium_core/services/rate_us/config_remote.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final testConfig = RateUsConfig(
    title: "Please, rate Save On app",
    text: "If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.",
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayId: 'fr.skyost.example',
    appStoreId: '1491556149',
  );

  test("printing rate_us config json", () {
    final json = jsonEncode(testConfig.toMap());
    print(json);
    RemoteRateUsConfigSerializer.fromMap(jsonDecode(json));
  });
}