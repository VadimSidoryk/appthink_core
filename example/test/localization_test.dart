import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/services/localization/config.dart';
import 'package:applithium_core_example/main.dart';
import 'package:applithium_core_example/picker/presentation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final notLocalizedContentValue = "Content Screen";
  final localizedContentValue = "Экран с контентом";

  final notLocalizedListValue = "List Screen";
  final localizedListValue = "Экран с листингом";

  final config = AplConfig(
      messagingApiKey: "",
      localizations: LocalizationConfig({
        CONTENT_SCREEN_TITLE: {
          DEFAULT_LOCALE_KEY: notLocalizedContentValue,
          "ru-RU": localizedContentValue
        },
        LIST_SCREEN_TITLE: {DEFAULT_LOCALE_KEY: notLocalizedListValue, "ru-RU": localizedListValue},
      }));

  testWidgets("app without locale", (tester) async {

    final MyApp app = MyApp(
      initialLinkProvider: () async => null,
      config: config,
    );
    await tester.pumpWidget(app);
    await tester.pump(new Duration(seconds: 3));
    await tester.pumpWidget(app);
    expect(find.text(notLocalizedContentValue), findsOneWidget);
    expect(find.text(notLocalizedListValue), findsOneWidget);
  });

  testWidgets("app with locale", (tester) async {

    final MyApp app = MyApp(
      initialLinkProvider: () async => null,
      config: config,
      locale: Locale("ru", "RU"),
    );
    await tester.pumpWidget(app);
    await tester.pump(new Duration(seconds: 3));
    await tester.pumpWidget(app);
    expect(find.text(localizedContentValue), findsOneWidget);
    expect(find.text(localizedListValue), findsOneWidget);
  });
}
