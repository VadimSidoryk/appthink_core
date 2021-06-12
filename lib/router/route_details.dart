import 'package:applithium_core/router/route_result.dart';
import 'package:flutter/cupertino.dart';

import 'matchers.dart';

typedef WidgetBuilderWithRouteResult = Widget Function(BuildContext, RouteResult);

class RouteDetails {
  final Matcher matcher;
  final WidgetBuilderWithRouteResult? builder;
  final List<RouteDetails> subRoutes;

  RouteDetails({this.matcher = const Matcher.any(), this.builder, this.subRoutes = const []});

  RouteResult evaluate(RouteResult parentResult) {
    final evaluation = matcher.evaluate(parentResult.remainingUri!);
    if (!evaluation.isMatch) return parentResult.withNoNestedMatch();

    final result = parentResult.withNestedMatch(
      evaluation,
          (context, result) {
        throw StateError('This result is temporary and should not be returned');
      },
    );

    final childRoutes = subRoutes;
    for (final route in childRoutes) {
      final childResult = route.evaluate(result);
      if (childResult.isMatch) return childResult;
    }


    if (builder == null) return parentResult.withNoNestedMatch();
    return parentResult.withNestedMatch(evaluation, builder!);
  }
}

