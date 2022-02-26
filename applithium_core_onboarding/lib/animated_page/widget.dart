import 'package:applithium_core_onboarding/animated_page/resources.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/action_button/widget.dart';

class AnimatedPage extends StatefulWidget {
  final int stepsCount;
  final Function(int)? onNextStep;

  AnimatedPage({Key? key, required this.stepsCount, this.onNextStep})
      : super(key: key);

  @override
  State createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  int _stepIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 64,
              child: Container(
                color: Color(0xFFF0E4D4),
                child: _buildTopSection(context, _stepIndex),
              )),
          Expanded(
              flex: 36,
              child: Container(
                color: Color(0xFFFBF6EF),
                padding: widget.marginBottomSection,
                child: _buildBottomSection(context, _stepIndex),
              ))
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, int step) {
    return Lottie.asset(widget.loOnboarding,
        width: MediaQuery.of(context).size.width,
        controller: _controller, onLoaded: (comp) {
      _controller..duration = comp.duration;
      _playNextStep();
    });
  }

  Widget _buildBottomSection(BuildContext context, int step) {
    final title =
        step < widget.titles.length ? widget.titles.elementAt(step) : "";
    final subTitle =
        step < widget.subTitle.length ? widget.subTitle.elementAt(step) : "";
    final buttonTitle = step < widget.buttonTitle.length
        ? widget.buttonTitle.elementAt(step)
        : "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Column(
            key: ValueKey(_stepIndex),
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                child: Text(title,
                    style: widget.textTitle, textAlign: TextAlign.center),
              ),
              Container(
                height: 55,
                child: Text(subTitle,
                    style: widget.textSubTitle, textAlign: TextAlign.center),
              )
            ],
          ),
          transitionBuilder: _textAnimation,
        ),
        // Spacer(),
        ActionButton(
            title: buttonTitle,
            onClick: () {
              setState(() {
                if (_stepIndex < widget.stepsCount) {
                  _stepIndex += 1;
                  _playNextStep();
                }
              });
            }),
      ],
    );
  }

  void _playNextStep() {
    if (_stepIndex < widget.stepsCount) {
      final frame = widget.animationFrames.elementAt(_stepIndex);
      _controller.animateTo(frame.toDouble());
    } else {
      widget.onNextStep?.call(_stepIndex);
    }
  }

  Widget _textAnimation(Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);

    final inAnimation =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);
    final outAnimation =
        Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);

    if (child.key == ValueKey(_stepIndex)) {
      return SlideTransition(
        key: ValueKey(_stepIndex),
        position: inAnimation,
        child: child,
      );
    } else {
      return SlideTransition(
        key: ValueKey(_stepIndex),
        position: outAnimation,
        child: child,
      );
    }
  }
}
