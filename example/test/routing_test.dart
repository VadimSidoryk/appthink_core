import 'package:applithium_core_example/main.dart';
import 'package:applithium_core_example/picker/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));
}

void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets("start app without deeplink", (tester) async {
    final MyApp app = MyApp();
    await tester.pumpWidget(app);
    await untilCalled(mockObserver.didReplace(newRoute: anyNamed("newRoute"), oldRoute: anyNamed("oldRoute")));
    expect(find.byType(PickerScreen), findsOneWidget);
  });
}
