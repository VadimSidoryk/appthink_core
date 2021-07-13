import 'package:applithium_core/app/base.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/mocks/utils.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/presentation/base_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return ApplithiumAppState<MyApp>(
        splashBuilder: (config) => Scaffold(
              body: Center(child: Text("Splash...")),
            ),
        title: "Applithium Core Example",
        analysts: {LogAnalyst()},
        configProvider: MockedConfigProvider(),
    layoutBuilder: MockedLayoutBuilder());
  }
}

class MockedConfigProvider extends ConfigProvider {
  @override
  Future<ApplicationConfig> getApplicationConfig() {
    return MockUtils.mockWithDelay(
        Duration(seconds: 2),
        ApplicationConfig(
            resources: ResourceConfig({"": {}}),
            eventHandlers: {},
            presentations: {
              "/": PresentationConfig("content", {}, {}, 20)
            }));
  }
}

class MockedLayoutBuilder extends AplLayoutBuilder {
  @override
  Widget buildLayout(uiConfig, Map<String, dynamic> args, EventHandler handler) {
    return Center(child: Text("Mocked layout builder"));
  }

}
