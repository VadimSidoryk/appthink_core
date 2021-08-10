import 'package:applithium_core/services/localization/config.dart';
import 'package:flutter/rendering.dart';

class AplConfig {

  factory AplConfig.getDefault() => AplConfig(messagingApiKey: "", localizations: LocalizationConfig({"": {}}));

  final String messagingApiKey;

  final LocalizationConfig localizations;

  AplConfig({
    required this.messagingApiKey,
    required this.localizations
  });

}
