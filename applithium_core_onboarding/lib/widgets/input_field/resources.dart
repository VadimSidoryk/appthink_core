import 'dart:ui';

import 'package:flutter/material.dart';

import 'widget.dart';

extension InutFieldStyles on InputField {
  get textField => TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: "SF Pro Rounded",
        fontWeight: FontWeight.w500,
      );

  InputDecoration decTextField(
          {String? hint, Widget? prefix, Color? fillColor, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffix: suffix,
        hintStyle: TextStyle(
          color: Color(0x66000000),
          fontSize: 18,
          fontFamily: "SF Pro Rounded",
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: fillColor ?? Color(0xFFFFFDFB),
      );
}
