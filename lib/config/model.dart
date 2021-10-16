import 'dart:convert';

const _KEY_MESSAGING_API_KEY = "messaging_api_key";
const _KEY_LOCALIZATION = "localization";

abstract class AplConfig {
  const AplConfig();

  String get messagingApiKey => getString(_KEY_MESSAGING_API_KEY);

  Map<String, dynamic> get localizationData =>
      jsonDecode(getString(_KEY_LOCALIZATION));

  String getString(String key);

  bool getBool(String key);

  int getInt(String key);

  double getDouble(String key);
}

class DefaultConfig extends AplConfig {
  final defaultBool;
  final defaultInt;
  final defaultDouble;
  final defaultString;

  final String _messagingApiKey;
  final Map<String, dynamic> values;

  const DefaultConfig(this._messagingApiKey,
      {this.values = const {},
      this.defaultBool = false,
      this.defaultInt = 0,
      this.defaultDouble = .0,
      this.defaultString = ""});

  @override
  String get messagingApiKey => _messagingApiKey;

  @override
  Map<String, dynamic> get localizationData => {};

  @override
  bool getBool(String key) {
    if (values.containsKey(key)) {
      return values[key];
    } else {
      return defaultBool;
    }
  }

  @override
  double getDouble(String key) {
    if (values.containsKey(key)) {
      return values[key];
    } else {
      return defaultDouble;
    }
  }

  @override
  int getInt(String key) {
    if (values.containsKey(key)) {
      return values[key];
    } else {
      return defaultInt;
    }
  }

  @override
  String getString(String key) {
    if (values.containsKey(key)) {
      return values[key];
    } else {
      return defaultString;
    }
  }
}
