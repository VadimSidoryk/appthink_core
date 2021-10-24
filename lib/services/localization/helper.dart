import 'dart:ui';
import 'config.dart';

class AplLocalization {
  final Map<String, String> _localizedStrings;

  AplLocalization(Locale locale, LocalizationConfig config): _localizedStrings = buildLocalizationMap(locale, config);

  static Map<String, String> buildLocalizationMap(Locale locale, LocalizationConfig config) {
    Map<String, String> result = Map();
    final keys = config.translations.keys;
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

extension _localizationConfigUtils on LocalizationConfig {
  String getTranslation(String key, String locale) {
    if(!translations.containsKey(key)) {
      return key;
    }
    final map = translations[key]!;
    if(!(map is Map<String, dynamic>) || !map.containsKey(locale)) {
      return key;
    } else {
      return map[locale]!;
    }
  }

}