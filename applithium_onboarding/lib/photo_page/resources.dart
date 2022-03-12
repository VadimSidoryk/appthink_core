import 'package:flutter/material.dart';

import 'widget.dart';

extension UserPhotoStrings on UserPhotoPage {
  get title => "Add a profile photo";
  get skipButton => "Skip";
  get addPhotoButton => "Add photo";
  get continueButton => "Continue";
}

extension UserPhotoAssets on UserPhotoPage {
  get icAddPhoto => "assets/images/ic_onb_add_photo.svg";
  get icBarBack => "assets/images/ic_app_bar_back.svg";
}

extension UserPhotoStyle on UserPhotoPage {
  get bgColor => Color(0xFFFBF6EF);

  get textTitle => TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w700,
      );

  get textSkip => TextStyle(
        color: Color(0xFF9A9A9A),
        fontSize: 18,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w500,
      );

  get distanceTitleAvatar => 45.0;

  get avatarDiameter => 143.0;
  get avatarIconHeight => 50.0;
  get avatarDecoration => BoxDecoration(
      color: Color(0xFFFFFDFA),
      borderRadius: BorderRadius.all(Radius.circular(143 / 2)),
      border: Border.all(color: Color(0xFFEFE6DB), width: 4));

  get skipButtonSize => Size(250, 50);
}
