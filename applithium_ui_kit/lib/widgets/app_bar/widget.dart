import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget CustomAppBar(
        {String? title,
        Color? background,
        bool? centerTitle,
        Widget? leading,
        Function()? onBack,
        List<Widget>? actions,
        Function()? onClose}) =>
    AppBar(
      leading: Container(
        child: _buildLeading(leading, onBack),
        padding: EdgeInsets.only(left: 15.0),
      ),
      title:
          title != null ? Text(title, style: CoupesStyles.textHeadline) : null,
      centerTitle: centerTitle,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: background ?? Color(0x00000000),
      actions: _buildActions(actions, onClose),
    );

Widget? _buildLeading(Widget? leading, Function()? onBackClicked) {
  if (leading != null) {
    return leading;
  } else {
    if (onBackClicked != null) {
      return GestureDetector(
          child: SvgPicture.asset("assets/images/ic_app_bar_back.svg"),
          onTap: onBackClicked);
    } else {
      return null;
    }
  }
}

List<Widget>? _buildActions(List<Widget>? actions, Function()? onClose) {
  if (actions != null) {
    return actions;
  } else {
    if (onClose != null) {
      return [
        Container(
          child: GestureDetector(
              child: SvgPicture.asset("assets/images/ic_app_bar_close.svg"),
              onTap: onClose),
          padding: EdgeInsets.only(right: 15.0),
        )
      ];
    } else {
      return null;
    }
  }
}
