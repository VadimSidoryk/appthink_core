import 'package:applithium_core/services/localization/config.dart';
import 'package:flutter/widgets.dart';

import 'helper.dart';

class AppLocalizationsDelegate
    extends LocalizationsDelegate<LocalizationHelper> {

  final LocalizationConfig config;

  const AppLocalizationsDelegate(this.config);

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<LocalizationHelper> load(Locale locale) async {
    return new LocalizationHelper(locale, config);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}