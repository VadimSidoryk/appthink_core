import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class AplWidget<R extends AplWidgetResources> extends StatefulWidget {
  final R Function(BuildContext, AplWidget) resourceProvider;
  R? resources;

  AplWidget({Key? key, required this.resourceProvider}) : super(key: key);
}

abstract class AplWidgetResources<W extends StatefulWidget> {
  final BuildContext context;
  final W widget;

  AplWidgetResources(this.context, this.widget);
}