
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {
}

void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets("start app without deeplink", (tester) async {
    final MyApp app = MyApp(
        observer: mockObserver, initialLinkProvider: () async => null);
    await tester.pumpWidget(app);
    await untilCalled(mockObserver.didPush(any, any));
    expect(find.text(splashTitle), findsOneWidget);
    // await tester.pumpAndSettle(new Duration(seconds: 5));
    // expect(find.byType(PickerScreen), findsOneWidget);
  });

  testWidgets("start app with /content deeplink", (tester) async {

      final MyApp app = MyApp(
          observer: mockObserver, initialLinkProvider: () async => "/content");
      await tester.pumpWidget(app);
      await untilCalled(mockObserver.didPush(any, any));
      expect(find.text(splashTitle), findsOneWidget);
      // await tester.pumpAndSettle(new Duration(seconds: 5));
      // expect(find.byType(ExampleContentScreen), findsOneWidget);

  });

  // testWidgets("start app with /list deeplink", (tester) async {
  //   final MyApp app = MyApp(observer: mockObserver, initialLinkProvider: () async => "/list");
  //   await tester.pumpWidget(app);
  //   await untilCalled(mockObserver.didPush(any, any));
  //   expect(find.text(splashTitle), findsOneWidget);
  //   await tester.pumpAndSettle(new Duration(seconds: 5));
  //   expect(find.byType(ExampleListingScreen), findsOneWidget);
  // });
}
