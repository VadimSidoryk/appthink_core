
import 'package:flutter/widgets.dart';

typedef EventHandler = Function({required String name, Map<String, Object>? params});

abstract class UIBuilder {
  Widget buildUI(String uiConfig, EventHandler handler);
}