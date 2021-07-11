
import 'package:flutter/widgets.dart';

typedef EventHandler = Function({required String name, Map<String, Object>? params});

abstract class PresentationBuilder {
  Widget buildUI(String uiConfig, EventHandler handler);
}