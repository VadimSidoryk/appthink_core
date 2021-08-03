import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applithium_core/scopes/extensions.dart';

void main() {
  final testDescription = "TestDescription";
  final testDescriptionFinder = find.text(testDescription);

  testWidgets('get value from scope via context extension',
      (WidgetTester tester) async {
    final store = Store()..add((provider) => testDescription);
    await tester.pumpWidget(Scope(
        parentContext: null,
        store: store,
        builder: (context) => _SampleWidgetWithDependency(
              builder: (context) => Text(context.get()),
            )));
    expect(testDescriptionFinder, findsOneWidget);
  });

  testWidgets("get instance from parent scope via context extension",
      (WidgetTester tester) async {
    final parentStore = Store()..add((provider) => testDescription);
    final childStore = Store()
      ..add((provider) => _ClassWithStringDependency(provider.get()));
    await tester.pumpWidget(Scope(
        parentContext: null,
        store: parentStore,
        builder: (context) => _BulkWidget(
            builder: (context) => Scope(
                parentContext: context,
                store: childStore,
                builder: (context) => _SampleWidgetWithDependency(
                      builder: (context) =>
                          Text(context.get<_ClassWithStringDependency>().text),
                    )))));
    expect(testDescriptionFinder, findsOneWidget);
  });
}

class _BulkWidget extends StatelessWidget {
  final WidgetBuilder builder;

  const _BulkWidget({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder.call(context);
  }
}

class _SampleWidgetWithDependency extends StatelessWidget {
  final WidgetBuilder builder;

  const _SampleWidgetWithDependency({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: builder.call(context),
        ),
      ),
    );
  }
}

class _ClassWithStringDependency {
  final String text;

  _ClassWithStringDependency(this.text);
}
