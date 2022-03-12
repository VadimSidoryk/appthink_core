import 'package:flutter/material.dart';

import 'widget.dart';

extension NamePageAssets on UserNamePage {
  get bgTop => "assets/images/bg_onb_name_page.svg";
  get icEditName => "assets/images/ic_edit_profile_edit.svg";
  get icBarBack => "assets/images/ic_app_bar_back.svg";
}

extension NamePageStrings on UserNamePage {
  get hintUsername => "Enter your name";
  get title => "What’s your name?";
  get subTitle =>
      "Use your first name or a secret\nname your buddy calls you to let\nthem know it’s you.";
  get buttonTitle => "Continue";
}

extension NamePageStyle on UserNamePage {
  get mainBgColor => Color(0xFFF7F0E7);

  get bottomContainerPadding => EdgeInsets.only(top: 35, left: 20, right: 20);
  get inputFieldPadding => const EdgeInsets.symmetric(horizontal: 15);

  get decoration => BoxDecoration(
      color: Color(0xFFF3E9DC),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(33), topRight: Radius.circular(33)));

  get styleTitle => TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w700,
      );

  get styleSubTitle => TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w400,
      );
}
