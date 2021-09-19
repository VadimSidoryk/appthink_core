import 'package:applithium_core/router/matchers.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core_example/picker/widget.dart';
import 'package:applithium_core/scopes/extensions.dart';

import 'content/domain/use_cases.dart';
import 'content/presentation/widget.dart';


final appStructure = [
  RouteDetails(
      builder: (context, result) =>
          PickerScreen(
              itemClicked: (item) =>
                  context.get<AplRouter>().applyRoute("/content"))
      , subRoutes: [
    RouteDetails(
        matcher: Matcher.path("content"),
        builder: (context, result) =>
            ExampleContentScreen(
              useCases: testUseCases,
              backClicked: () => context.get<AplRouter>().back(),
            ))
  ]),
];