import 'dart:convert';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/localization/config.dart';
import 'package:applithium_core/services/localization/helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../service_base.dart';

typedef LocalizationBuilder = AplLocalization Function(Locale);

class LocalizationService extends AplService {
  late LocalizationConfig _config;

  LocalizationService();

  List<Locale> get supportedLocales =>
      _config.getSupportedLocaleCodes().map((item) => item.toLocale()).toList();

  @override
  Future<void> init(AplConfig appConfig) async {
    _config = appConfig.localizationConfig;
  }

  @override
  void addToStore(Store store) {
    store.add((provider) => this);
    store.add<LocalizationBuilder>(
        (provider) => (locale) => AplLocalization(locale, _config));
  }
}

extension _RemoteLocalizationConfig on AplConfig {
  static const _KEY_LOCALIZATION = "localization";

  LocalizationConfig get localizationConfig {
    final result = this.getString(_KEY_LOCALIZATION);
    if(result.value != null) {
      final json = jsonDecode(result.value!);
      return LocalizationConfig(json);
    } else {
      return LocalizationConfig({});
    }
  }
}

extension _LocalizationConfigUtils on LocalizationConfig {
  Set<String> getSupportedLocaleCodes() {
    final result = <String>{};
    for (String key in translations.keys) {
      final map = translations[key]!;
      if (map is Map<String, dynamic>) {
        result.addAll(map.keys);
      }
    }
    if (result.isNotEmpty) {
      return result..add(DEFAULT_LOCALE_KEY);
    } else {
      return {DEFAULT_LOCALE_KEY};
    }
  }
}

extension _LocaleHelper on String {
  Locale toLocale({String separator = '-'}) {
    final localeList = split(separator);
    switch (localeList.length) {
      case 2:
        return Locale(localeList.first, localeList.last);
      case 3:
        return Locale.fromSubtags(
          languageCode: localeList.first,
          scriptCode: localeList[1],
          countryCode: localeList.last,
        );
      default:
        return Locale(localeList.first);
    }
  }
}
