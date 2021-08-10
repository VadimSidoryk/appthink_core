import 'package:flutter/widgets.dart';

import 'helper.dart';

extension TranslatableText on Text {
  Text tr(BuildContext context) => Text(
      Localizations.of<LocalizationHelper>(context, LocalizationHelper)
              ?.translate(data!) ??
          "Can't find localization",
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
