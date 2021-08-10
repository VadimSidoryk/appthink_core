import 'package:applithium_core/services/localization/config.dart';
import 'package:applithium_core/services/localization/helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final key1 = "key1";
  final notLocalizedValue = "Not localized Value";
  final localizedValue = "Локализованное значение";

  final key2 = "key2";

  test("find default string", () {
    final config = LocalizationConfig({
      key1: {DEFAULT_LOCALE_KEY: notLocalizedValue}
    });
    final helper = LocalizationHelper(Locale("ru", "RU"), config);
    assert(helper.translate(key1) == notLocalizedValue);
  });

  test("is transform to locale code is valid", () {
    final config = LocalizationConfig({
      key1: {DEFAULT_LOCALE_KEY: notLocalizedValue, "ru-RU": localizedValue}
    });
    final helper = LocalizationHelper(Locale("ru", "RU"), config);
    assert(helper.translate(key1) == localizedValue);
  });

  test("combine default and not default", () {
    final config = LocalizationConfig({
      key1: {DEFAULT_LOCALE_KEY: notLocalizedValue, "ru-RU": localizedValue},
      key2: {DEFAULT_LOCALE_KEY: notLocalizedValue}
    });
    final helper = LocalizationHelper(Locale("ru-RU"), config);
    assert(helper.translate(key1) == localizedValue);
    assert(helper.translate(key2) == notLocalizedValue);
  });
}
