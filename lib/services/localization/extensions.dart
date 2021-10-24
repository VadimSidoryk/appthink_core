import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

import 'helper.dart';

extension TranslatableText on Text {
  Text tr(BuildContext context) => Text(
      Localizations.of<AplLocalization>(context, AplLocalization)
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


