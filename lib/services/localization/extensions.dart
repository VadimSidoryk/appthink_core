import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

import 'helper.dart';

extension TranslatableText on Text {
  Text tr(BuildContext context) => Text(
      Localizations.of<LocalizationHelper>(context, LocalizationHelper)
              ?.translate(data!) ?? data!..logError("Can't find localization"),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis);
}

extension LocaleHelper on String {
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
