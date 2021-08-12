import 'package:applithium_core/services/localization/config.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LocalizationHelper {
  final Map<String, String> _localizedStrings;

  LocalizationHelper(Locale locale, LocalizationConfig config): _localizedStrings = buildLocalizationMap(locale, config);

  static Map<String, String> buildLocalizationMap(Locale locale, LocalizationConfig config) {
    Map<String, String> result = Map();
    final keys = config.getAllKeys();
    for(String key in keys) {
      result[key] = config.getTranslation(key, locale.toLanguageTag());
    }
    return result;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String key) {
    return _localizedStrings[key];
  }
}