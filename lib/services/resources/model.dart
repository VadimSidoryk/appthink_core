class ResourceConfig {
  final Map<String, Map<String, String>> _stringData;

  factory ResourceConfig.fromMap(Map<String, Map<String, String>> map) => ResourceConfig(map);

  ResourceConfig(this._stringData);
  
  bool hasStringsForLanguage(String languageCode) {
    return _stringData.containsKey(languageCode);
  }

  Map<String, String> getStringsForLanguage(String locale) {
    return _stringData[locale];
  }

  Map<String, String> getDefaultStrings() {
    return _stringData[null];
  }
}