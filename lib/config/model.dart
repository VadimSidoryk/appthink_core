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

  final Map<String, dynamic> values;

  const DefaultConfig(this._messagingApiKey,
      {this.values = const {},
        this.defaultBool = false,
        this.defaultInt = 0,
        this.defaultDouble = .0,
        this.defaultString = ""});

  @override
  Either<bool> getBool(String key) {
    if (values.containsKey(key)) {
      return Either.withValue(values[key]);
    } else {
      return Either.withValue(defaultBool);
    }
  }

  @override
  Either<double> getDouble(String key) {
    if (values.containsKey(key)) {
      return Either.withValue(values[key]);
    } else {
      return Either.withValue(defaultDouble);
    }
  }

  @override
  Either<int> getInt(String key) {
    if (values.containsKey(key)) {
      return Either.withValue(values[key]);
    } else {
      return Either.withValue(defaultInt);
    }
  }

  @override
  Either<String> getString(String key) {
    if (values.containsKey(key)) {
      return Either.withValue(values[key]);
    } else {
      return Either.withValue(defaultString);
    }
  }
}
