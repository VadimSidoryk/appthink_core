import 'package:flutter/widgets.dart';

abstract class AplService<C> {
  void init(BuildContext context, C config);
}