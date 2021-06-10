import 'package:applithium_core/router/matchers.dart';
import 'package:applithium_core/router/partial_uri.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'route_details.dart';

@immutable
class RouteResult {
  const RouteResult.noMatch(this.settings)
      : isMatch = false,
        remainingUri = null,
        parameters = const {},
        builder = null;

  const RouteResult.match(
      this.settings, {
        required PartialUri this.remainingUri,
        this.parameters = const {},
        required WidgetBuilderWithRouteResult builder,
      })   : isMatch = true,
  // ignore: prefer_initializing_formals
        builder = builder;

  RouteResult.root(this.settings)
      : isMatch = true,
        remainingUri = PartialUri.parse(settings.name!),
        parameters = {},
        builder = null;

  /// The [RouteSettings] given by a [Navigator] for use in the [flutter.Route]
  /// generated by [builder].
  final RouteSettings settings;

  /// The original [Uri] that was requested.
  Uri get uri => Uri.parse(settings.name!);

  /// `true` if the [uri] was matched, `false` otherwise.
  final bool isMatch;

  /// Parts of the original [uri] that are left after matching.
  final PartialUri? remainingUri;

  /// Parameters, e.g. from path segments.
  final Map<String, String> parameters;

  /// The [WidgetBuilderWithRouteResult] to construct a [flutter.Route] for this match.
  final WidgetBuilderWithRouteResult? builder;

  RouteResult withNestedMatch(
      MatcherEvaluation evaluation,
      WidgetBuilderWithRouteResult builder,
      ) {
    return RouteResult.match(
      settings,
      builder: builder,
      remainingUri: evaluation.remainingUri!,
      parameters: {...parameters, ...evaluation.parameters},
    );
  }

  RouteResult withNoNestedMatch() => RouteResult.noMatch(settings);

  String? operator [](String key) => parameters[key];
  Route<dynamic> build() {
    assert(isMatch);

    return MaterialPageRoute(builder: (BuildContext context) => builder!(context, this));
  }

  @override
  String toString() {
    if (!isMatch) return 'no match';
    return 'match: $parameters, remaining: $remainingUri';
  }

  @override
  bool operator ==(Object other) {
    return other is RouteResult &&
        uri == other.uri &&
        isMatch == other.isMatch &&
        remainingUri == other.remainingUri &&
        mapEquals(parameters, other.parameters);
  }

  @override
  int get hashCode => hashValues(isMatch, remainingUri, parameters);
}