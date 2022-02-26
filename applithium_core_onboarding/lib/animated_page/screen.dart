import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/screen_with_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
import 'events.dart';
import 'state.dart';
import 'widget.dart';

class AnimatedPageScreen extends StatefulWidget {
  final Function()? onFinish;

  AnimatedPageScreen({Key? key, this.onFinish}) : super(key: key);

  @override
  State createState() => _AnimatedPageScreenState();
}

class _AnimatedPageScreenState extends AplBlocScreenState<AnimatedPageScreen,
    AnimatedPageEvent, AnimatedPageState> {
  @override
  AplBloc<AnimatedPageState> createBloc(BuildContext context) {
    return AnimatedPageBloc(3, onFinish: widget.onFinish);
  }

  @override
  Widget createWidget(BuildContext context, state) {
    return AnimatedPage(
      stepsCount: state.stepsCount,
      onNextStep: send1(AnimatedPageEvent.nextPage),
    );
  }
}
