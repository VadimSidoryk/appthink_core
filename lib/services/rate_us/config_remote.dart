import 'package:flutter/foundation.dart';

import 'config.dart';

extension RemoteRateUsConfigSerializer on RateUsConfig {
  static const _KEY_TITLE = "title";
  static const _KEY_TEXT = "text";
  static const _KEY_PLAY_ID = "google_play_id";
  static const _KEY_APP_STORE_ID = "app_store_id";
  static const _KEY_MIN_DAYS = "min_days";
  static const _KEY_MIN_LAUNCHES = "min_launches";
  static const _KEY_REMIND_DAYS = "remind_days";
  static const _KEY_REMIND_LAUNCHES = "remind_launches";

  static RateUsConfig fromMap(Map<String, dynamic> map) {
    return RateUsConfig(
        title: map[_KEY_TITLE],
        text: map[_KEY_TEXT],
        googlePlayId: map[_KEY_PLAY_ID],
        appStoreId: map[_KEY_APP_STORE_ID],
        minDays: map[_KEY_MIN_DAYS] ?? 7,
        minLaunches: map[_KEY_MIN_LAUNCHES] ?? 10,
        remindDays: map[_KEY_REMIND_DAYS] ?? 7,
        remindLaunches: map[_KEY_REMIND_LAUNCHES] ?? 10);
  }

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return {
      _KEY_TITLE: title,
      _KEY_TEXT: text,
      _KEY_PLAY_ID: googlePlayId,
      _KEY_APP_STORE_ID: appStoreId,
      _KEY_MIN_DAYS: minDays,
      _KEY_MIN_LAUNCHES: minLaunches,
      _KEY_REMIND_DAYS: remindDays,
      _KEY_REMIND_LAUNCHES: remindLaunches
    };
  }
}