import 'package:flutter/material.dart';

import 'widget.dart';

extension ActionButtonStyles on ActionButton {
  get styleAction => TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontFamily: "SF Pro Rounded",
    fontWeight: FontWeight.w700,
  );

  get decorationAction => ElevatedButton.styleFrom(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      primary: Color(0xff4abf95),
      shape:
      (RoundedRectangleBorder(borderRadius: BorderRadius.circular(34.0))));
}