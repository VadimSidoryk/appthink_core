import 'dart:convert';

import 'package:appthink_core/services/share/config.dart';
import 'package:appthink_core/services/share/config_remote.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final shareConfig = ShareConfig(
      intentToSubject: {
        "" : "Hey there is a wonderful app",
      },
      intentToText: {
        "" : "Install Save On app"
      }
  );

  test("printing rate_us config json", () {
    final json = jsonEncode(shareConfig.toMap());
    print(json);
    RemoteShareConfigSerializer.fromMap(jsonDecode(json));
  });
}