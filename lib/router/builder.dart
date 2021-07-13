import 'package:applithium_core/presentation/base.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/router/matchers.dart';
import 'package:applithium_core/router/route_details.dart';

class RoutesBuilder {
  static List<RouteDetails> fromPresentationsMap(
    Map<String, AplPresentationBuilder> typeToBuilders,
    AplLayoutBuilder layoutBuilder,
    Map<String, PresentationConfig> config,
  ) {
    return config.entries.map((entry) {
      final path = entry.key;
      final builder = typeToBuilders[entry.value.type]!;
      return RouteDetails(
          matcher: Matcher.host(path),
          builder: (context, details) {
            return AplPresentation(
              stateToUI: entry.value.stateToUI,
              layoutBuilder: layoutBuilder,
              currentBlocFactory:
                  builder.buildPresentation(context, entry.value),
            );
          });
    }).toList();
  }

  RoutesBuilder._();
}
