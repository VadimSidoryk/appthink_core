
const DEFAULT_LOCALE_KEY = "en-US";

class LocalizationConfig {
  final Map<String, dynamic> _stringData;

  const LocalizationConfig(this._stringData);

  Iterable<String> getAllKeys() {
    return _stringData.keys;
  }

  String getTranslation(String key, String locale) {
    if(!_stringData.containsKey(key)) {
      return key;
    }
    final map = _stringData[key]!;
    if(!(map is Map<String, dynamic>) || !map.containsKey(locale)) {
      return key;
    } else {
      return map[locale]!;
    }
  }

  Set<String> getSupportedLocaleCodes() {
    final result = <String>{};
    for(String key in _stringData.keys) {
      final map = _stringData[key]!;
      if(map is Map<String, dynamic>) {
        result.addAll(map.keys);
      }

    }
    if(result.isNotEmpty) {
      return result..add(DEFAULT_LOCALE_KEY);
    } else {
      return { DEFAULT_LOCALE_KEY };
    }
  }
}