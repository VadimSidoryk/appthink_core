import 'package:appthink_core/router/route_details.dart';
import 'package:appthink_core/router/router.dart';
import 'package:appthink_core/scopes/extensions.dart';
import 'package:appthink_core_example/picker/widget.dart';

final mainAppGraph = [
  RouteDetails(
      builder: (context, result) => PickerScreen(
          itemClicked: (item) =>
              context.get<AplRouter>().push(item.path))),
];

