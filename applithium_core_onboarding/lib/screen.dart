import 'package:applithium_core/presentation/screen_parent.dart';
import 'package:applithium_core_onboarding/controller.dart';
import 'package:flutter/material.dart';

import 'animated_page/screen.dart';
import 'name_page/screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const ROUTE_START = "start";
  static const ROUTE_NAME = "name";
  static const ROUTE_PHOTO = "photo";
  static const ROUTE_NOTIFICATIONS = "notifications";
  static const ROUTE_SHOP = "shop";
  static const ROUTE_AUTH_CHOOSE = "auth_choose";
  static const ROUTE_LOGIN = "login";

  final OnboardingController controller;

  final OnboardingPage startPage;
  final Function()? onFinish;

  OnboardingScreen(
      {Key? key,
      required this.controller,
      required this.startPage,
      this.onFinish})
      : super(key: key);

  @override
  State createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends AplParentScreenState<OnboardingScreen> {
  AuthFlowType _flowType = AuthFlowType.signIn;

  @override
  String get initialRoute {
    switch (widget.startPage) {
      case OnboardingPage.name:
        return OnboardingScreen.ROUTE_NAME;
      case OnboardingPage.photo:
        return OnboardingScreen.ROUTE_PHOTO;
      default:
        return OnboardingScreen.ROUTE_START;
    }
  }

  @override
  Map<String, WidgetBuilder> get routes => {
        OnboardingScreen.ROUTE_START: (context) =>
            AnimatedPageScreen(onFinish: widget.onFinish),
        OnboardingScreen.ROUTE_NAME: (context) => NamePageScreen(
              controller: widget.controller,
              onContinue: () =>
                  Navigator.pushNamed(context, OnboardingScreen.ROUTE_PHOTO),
            ),
        OnboardingScreen.ROUTE_PHOTO: (context) => PhotoPageScreen(
              controller: widget.controller,
              onContinue: widget.onFinish,
              onBack: () => Navigator.pop(context),
            ),
        OnboardingScreen.ROUTE_NOTIFICATIONS: (context) =>
            NotificationsPageScreen(
              onFinish: () {},
            ),
        OnboardingScreen.ROUTE_AUTH_CHOOSE: (context) => AuthStartScreen(
              controller: widget.controller,
              onSignIn: () => _navigateToLogin(context, AuthFlowType.signIn),
              onSignUp: () => _navigateToLogin(context, AuthFlowType.signUp),
            ),
        OnboardingScreen.ROUTE_LOGIN: (context) => AuthCoverScreen(
              userRepo: widget.userRepo,
              type: _flowType,
            )
      };

  void _navigateToLogin(BuildContext context, AuthFlowType type) {
    _flowType = type;
    Navigator.pushNamed(context, OnboardingScreen.ROUTE_LOGIN);
  }
}

enum OnboardingPage { start, name, photo }
