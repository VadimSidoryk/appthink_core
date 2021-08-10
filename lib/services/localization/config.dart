class LocalizationConfig {
  final Map<String, Map<String, String>> _stringData;

  factory LocalizationConfig.fromMap(Map<String, Map<String, String>> map) => LocalizationConfig(map);

  LocalizationConfig(this._stringData);

  Iterable<String> getAllKeys() {
    return _stringData.keys;
  }

  String getTranslation(String key, String locale) {
    final map = _stringData[key]!;
    if(map.containsKey(locale)) {
      return map[locale]!;
    } else {
      return map[""]!;
    }
  }
}