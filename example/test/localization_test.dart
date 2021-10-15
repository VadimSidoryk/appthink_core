import 'package:applithium_core/config/model.dart';
import 'package:applithium_core_example/main.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final notLocalizedContentValue = "Content screen";
  final localizedContentValue = "Экран отображения контента";

  final notLocalizedListValue = "List screen";
  final localizedListValue = "Экран отображения листа";

  final config = DefaultConfig(
      values: { "messaging_api_key": "",
        "localization": "{"
        "\"$notLocalizedContentValue\": {"
            "\"ru-RU\": \"$localizedContentValue\""
            "},"
            "\"$notLocalizedListValue\": {"
            "\"ru-RU\": \"$localizedListValue\""
            "}"
            "}"
      });

  testWidgets("app without locale", (tester) async {
    final MyApp app = MyApp(
      initialLinkProvider: () async => null,
      config: config,
    );
    await tester.pumpWidget(app);
    await tester.pump(new Duration(seconds: 5));
    await tester.pumpWidget(app);
    // expect(find.text(localizedContentValue), findsOneWidget);
    // expect(find.text(localizedListValue), findsOneWidget);
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
    // expect(find.text(localizedContentValue), findsOneWidget);
    // expect(find.text(localizedListValue), findsOneWidget);
  });
}
