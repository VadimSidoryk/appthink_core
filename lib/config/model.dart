import 'package:applithium_core/services/localization/config.dart';
import 'package:flutter/rendering.dart';

class AplConfig {

  final String messagingApiKey;

  final LocalizationConfig localizations;

  const AplConfig({
    required this.messagingApiKey,
    required this.localizations
  });

}
