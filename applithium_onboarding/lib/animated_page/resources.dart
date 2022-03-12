import 'package:flutter/material.dart';

import 'widget.dart';

extension AnimatedPageAssets on AnimatedPage {
  get loOnboarding => "assets/lottie/onboarding.json";
}

extension AnimatedPageStrings on AnimatedPage {
  get titles => [
        "Made with love. Made\nfor love",
        "Made with love to spark\nyour passion",
        "Connect easily"
      ];
  get subTitle => [
        "",
        "Take your couple’s adventure to the next level",
        "Invite your partner to Couples and have fun taking quizzes"
      ];
  get buttonTitle => ["Get Started", "Continue", "Continue"];
}

extension AnimatedPageStyles on AnimatedPage {
  get animationFrames => [0.33, 0.53, 1.0];

  get marginBottomSection => EdgeInsets.only(left: 20, right: 20, top: 15);

  get textTitle => TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w700,
      );
  get textSubTitle => TextStyle(
        color: Colors.black,
        fontSize: 19,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w500,
      );
}
