import 'package:flutter/material.dart';

class ActionSheetKitStyles {
  TextStyle actionSheetButton(bool isDestructive) => TextStyle(
    color: isDestructive ? Colors.red : Color(0xFF4A88FF),
    fontSize: 18,
    fontFamily: "SF Pro Rounded",
    fontWeight: FontWeight.w400,
  );
  final actionSheetCancel = TextStyle(
    color: Color(0xFF4A88FF),
    fontSize: 18,
    fontFamily: "SF Pro Rounded",
    fontWeight: FontWeight.w600,
  );
}

class ActionSheetKitStrings {
  final takePhoto = "Take photo";
  final fromGallery = "From gallery";
  final deletePhoto = "Delete photo";
  final cancel = "Cancel";
}