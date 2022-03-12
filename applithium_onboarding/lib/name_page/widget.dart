import 'package:applithium_core/utils/extension.dart';
import 'package:applithium_core_onboarding/widgets/action_button/widget.dart';
import 'package:applithium_core_onboarding/widgets/input_field/widget.dart';
import 'package:applithium_core_onboarding/widgets/keyboard_avoider/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'resources.dart';

class UserNamePage extends StatelessWidget {
  final Stream<bool> isButtonEnabled;
  final Function()? onFinish;
  final Function(String?)? onNameChanged;
  final Function()? onBack;

  UserNamePage({
    Key? key,
    required this.isButtonEnabled,
    this.onFinish,
    this.onNameChanged,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return KeyboardAvoider(
      autoScroll: true,
      focusPadding: 50,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: mainBgColor,
        child: Column(
          children: [
            Expanded(
                flex: 48,
                child: SvgPicture.asset(bgTop,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width)),
            Expanded(
                flex: 52,
                child: Container(
                  decoration: decoration,
                  padding: bottomContainerPadding,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Text(title, style: styleTitle),
                        Spacer(),
                        Text(subTitle,
                            style: styleSubTitle, textAlign: TextAlign.center),
                        Spacer(flex: 2),
                        Padding(
                          padding: inputFieldPadding,
                          child: InputField(
                            hint: hintUsername,
                            initialValue: "",
                            suffix: SvgPicture.asset(icEditName),
                            onChanged: (value) {
                              onNameChanged?.call(value);
                            },
                          ),
                        ),
                        Spacer(flex: 4),
                        isButtonEnabled.view(_buildActionButton,
                            loadingBuilder: (context) {
                          return _buildActionButton(false);
                        }),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isEnabled) {
    return ActionButton(
        title: buttonTitle, onClick: isEnabled ? onFinish : null);
  }
}
