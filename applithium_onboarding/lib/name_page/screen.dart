import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/screen_with_bloc.dart';
import 'package:applithium_core_onboarding/controller.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
import 'events.dart';
import 'state.dart';
import 'widget.dart';

class NamePageScreen extends StatefulWidget {
  final OnboardingController controller;
  final Function()? onBack;
  final Function()? onContinue;

  NamePageScreen(
      {Key? key, required this.controller, this.onBack, this.onContinue})
      : super(key: key);

  @override
  State createState() => _NamePageScreenState();
}

class _NamePageScreenState extends AplBlocScreenState<NamePageScreen,
    UserNamePageEvents, UserNamePageState> {
  @override
  AplBloc<UserNamePageState> createBloc(BuildContext context) {
    return UserNamePageBloc(
      widget.controller,
      onBack: widget.onBack,
      onContinue: widget.onContinue,
    );
  }

  @override
  Widget createWidget(BuildContext context, UserNamePageState state) {
    return UserNamePage(
      isButtonEnabled: stateStream().map((it) => it.isContinueEnabled),
      onFinish: send0(UserNamePageEvents.continueClicked),
      onNameChanged: send1(UserNamePageEvents.nameChanged),
      onBack: send0(UserNamePageEvents.backClicked),
    );
  }
}
