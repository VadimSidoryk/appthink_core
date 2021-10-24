import 'package:applithium_core/utils/either.dart';

abstract class AplConfig {
  const AplConfig();

  Either<String> getString(String key);

  Either<bool> getBool(String key);

  Either<int> getInt(String key);

  Either<double> getDouble(String key);
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
