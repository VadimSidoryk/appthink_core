import 'dart:convert';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/service_base.dart';
import 'package:share/share.dart';
import 'package:sprintf/sprintf.dart';

import 'config.dart';
import 'config_remote.dart';
import 'package:applithium_core/logs/extension.dart';

class ShareService extends AplService {
  late ShareConfig config;

  @override
  Future<void> init(AplConfig appConfig) async {
    config = appConfig.shareConfig;
  }

  void share(
      {String intent = VAL_DEFAULT_INTENT, List<Object> params = const []}) {
    logMethod("share", params: [intent, params]);

    String shareText = config.intentToText.containsKey(intent)
        ? config.intentToText[intent]
        : config.intentToText[VAL_DEFAULT_INTENT];

    if(params.isNotEmpty) {
      shareText = sprintf(shareText, params);
    }

    Share.share(
        shareText,
        subject: config.intentToSubject.containsKey(intent)
            ? config.intentToSubject[intent]
            : config.intentToSubject[VAL_DEFAULT_INTENT]);
  }

  @override
  void addToStore(Store store) {
    store.add((provider) => this);
  }
}

extension _RemoteShareConfig on AplConfig {
  static const _KEY_SHARE = "share";

  ShareConfig get shareConfig {
    final result = this.getString(_KEY_SHARE);
    if(result.value != null) {
      final json = jsonDecode(result.value!);
      return RemoteShareConfigSerializer.fromMap(json);
    } else {
      throw result.exception ?? "Share config wasn't provided";
    }
  }
}
