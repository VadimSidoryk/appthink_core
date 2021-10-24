import 'package:applithium_core/services/localization/helper.dart';
import 'package:flutter/widgets.dart';

import 'service.dart';

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AplLocalization> {

  final LocalizationBuilder builder;

  const AppLocalizationsDelegate(this.builder);

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<AplLocalization> load(Locale locale) async {
    return builder.call(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}