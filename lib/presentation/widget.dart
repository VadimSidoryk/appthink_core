import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class AplWidget<R extends AplWidgetResources> extends StatefulWidget {
  final R Function(BuildContext, AplWidget) resourceProvider;
  R? _resources;

  R res(BuildContext context) {
    if(_resources != null) {
      return _resources!;
    } else {
      _resources = resourceProvider.call(context, this);
      return _resources!;
  }
}

  AplWidget({Key? key, required this.resourceProvider}) : super(key: key);
}

abstract class AplWidgetResources<W extends StatefulWidget> { }

abstract class AplState<R extends AplWidgetResources, W extends AplWidget<R>>  extends State<W> {
  R get res => widget.res(context);
}