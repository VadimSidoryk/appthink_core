abstract class AplConfig {
  const AplConfig();

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

  const DefaultConfig(
      {this.values = const {},
      this.defaultBool = false,
      this.defaultInt = 0,
      this.defaultDouble = .0,
      this.defaultString = ""});

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
