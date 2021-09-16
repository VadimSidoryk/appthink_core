
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core_example/content/.presentation/widget.dart';
import 'package:applithium_core_example/listing/presentation.dart';
import 'package:applithium_core_example/main.dart';
import 'package:applithium_core_example/picker/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    logMethod("didPop", params: [route, previousRoute]);
    super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]));
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    logMethod("didPush", params: [route, previousRoute]);
    super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));
  }

  @override
  void didRemove(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    logMethod("didRemove", params: [route, previousRoute]);
    super.noSuchMethod(Invocation.method(#didRemove, [route, previousRoute]));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logMethod("didReplace", params: [newRoute, oldRoute]);
    super.noSuchMethod(Invocation.method(
        #didReplace, [], {#newRoute: newRoute, #oldRoute: oldRoute}));
  }
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
    await tester.pumpAndSettle(new Duration(seconds: 3));
    expect(find.byType(PickerScreen), findsOneWidget);
  });

  testWidgets("start app with /content deeplink", (tester) async {

      final MyApp app = MyApp(
          observer: mockObserver, initialLinkProvider: () async => "/content");
      await tester.pumpWidget(app);
      await untilCalled(mockObserver.didPush(any, any));
      expect(find.text(splashTitle), findsOneWidget);
      await tester.pumpAndSettle(new Duration(seconds: 5));
      expect(find.byType(ContentScreen), findsOneWidget);

  });

  testWidgets("start app with /list deeplink", (tester) async {
    final MyApp app = MyApp(observer: mockObserver, initialLinkProvider: () async => "/list");
    await tester.pumpWidget(app);
    await untilCalled(mockObserver.didPush(any, any));
    expect(find.text(splashTitle), findsOneWidget);
    await tester.pumpAndSettle(new Duration(seconds: 5));
    expect(find.byType(ListingScreen), findsOneWidget);
  });
}
