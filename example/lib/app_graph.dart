import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core_example/picker/widget.dart';

final mainAppGraph = [
  RouteDetails(
      builder: (context, result) => PickerScreen(
          itemClicked: (item) =>
              context.get<AplRouter>().push(item.path))),
];

