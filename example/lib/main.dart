import 'package:applithium_core/app/base.dart';
import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/mocks/utils.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/presentation/content/bloc.dart';
import 'package:applithium_core/services/analytics/log_analyst.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/usecases/mocks/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ScreenBuilder = Widget Function(BaseState state);

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
        layoutBuilder: MockedLayoutBuilder((e) => Text(e)));
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
              "/" : PresentationConfig(
                  "content",
                  {
                    STATE_BASE_INITIAL_TAG: (BaseState state) => "{type: \"Text\"}",
                    STATE_BASE_ERROR_KEY: (BaseState state) => Text("Error"),
                    STATE_CONTENT_LOADING: (BaseState state) => Text("loading"),
                    STATE_BASE_DATA_TAG: (BaseState state) => Text("data")
                  },
                  {
                    EVENT_UPDATE_REQUESTED_NAME:
                        MockValueUseCase(TestState("title", "subtitle"), delayMillis: 5000)
                  },
                  20)
            }));
  }
}

class MockedLayoutBuilder extends AplLayoutBuilder<ScreenBuilder> {

  MockedLayoutBuilder(ErrorPageBuilder errorPageBuilder) : super(errorPageBuilder);

  @override
  Widget buildLayoutImpl(BuildContext context, ScreenBuilder uiConfig, BaseState state, EventHandler handler) {
    return Center(child: uiConfig.call(state));
  }
}

class TestState {
  final String title;
  final String description;

  TestState(this.title, this.description);
}
