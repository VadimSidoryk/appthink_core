import 'package:flutter/foundation.dart';

import 'config.dart';

extension RemoteShareConfigSerializer on ShareConfig {
  static const _KEY_INTENT_TO_SUBJECT = "intent_to_subject";
  static const _KEY_INTENT_TO_TEXT = "intent_to_text";

  static ShareConfig fromMap(Map<String, dynamic> map) {
    return ShareConfig(
        intentToSubject: map[_KEY_INTENT_TO_SUBJECT],
        intentToText: map[_KEY_INTENT_TO_TEXT]);
  }

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return {
      _KEY_INTENT_TO_SUBJECT: intentToSubject,
      _KEY_INTENT_TO_TEXT: intentToText
    };
  }
}