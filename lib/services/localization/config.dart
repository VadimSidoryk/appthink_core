
const DEFAULT_LOCALE_KEY = "en-US";

class LocalizationConfig {
  final Map<String, Map<String, String>> _stringData;

  const LocalizationConfig(this._stringData);

  Iterable<String> getAllKeys() {
    return _stringData.keys;
  }

  String getTranslation(String key, String locale) {
    final map = _stringData[key]!;
    if(map.containsKey(locale)) {
      return map[locale]!;
    } else {
      return map[DEFAULT_LOCALE_KEY]!;
    }
  }

  Set<String> getSupportedLocaleCodes() {
    final result = <String>{};
    for(String key in _stringData.keys) {
      result.addAll(_stringData[key]!.keys);
    }
    if(result.isNotEmpty) {
      return result;
    } else {
      return { DEFAULT_LOCALE_KEY };
    }
  }
}