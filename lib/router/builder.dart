import 'package:applithium_core/presentation/base_presentation.dart';
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
          matcher: getMatcherDependsOnPath(path),
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

  static Matcher getMatcherDependsOnPath(String path) {
    switch (path) {
      case "/":
        return Matcher.any();
      default:
        return Matcher.host(path);
    }
  }

  RoutesBuilder._();
}
