import 'dart:convert';

import 'package:applithium_core/config/model.dart';
import 'package:share/share.dart';
import 'package:sprintf/sprintf.dart';

import 'config.dart';
import 'config_remote.dart';

class ShareService {
  late ShareConfig _config;

  ShareService(AplConfig config) {
    _init(config);
  }

  Future<void> _init(AplConfig appConfig) async {
    _config = appConfig.shareConfig;
  }

  void share(
      {String intent = VAL_DEFAULT_INTENT, List<Object> params = const []}) {
    String shareText = _config.intentToText.containsKey(intent)
        ? _config.intentToText[intent]
        : _config.intentToText[VAL_DEFAULT_INTENT];

    if (params.isNotEmpty) {
      shareText = sprintf(shareText, params);
    }

    Share.share(shareText,
        subject: _config.intentToSubject.containsKey(intent)
            ? _config.intentToSubject[intent]
            : _config.intentToSubject[VAL_DEFAULT_INTENT]);
  }
}

extension _RemoteShareConfig on AplConfig {
  static const _KEY_SHARE = "share";

  ShareConfig get shareConfig {
    final result = this.getString(_KEY_SHARE);
    final json = jsonDecode(result);
    return RemoteShareConfigSerializer.fromMap(json);
  }
}
