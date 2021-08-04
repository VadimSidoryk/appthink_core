import 'package:applithium_core_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("start app without deeplink", (tester) async {
    final MyApp app = MyApp();
    await tester.pumpWidget(app);
  });

}

