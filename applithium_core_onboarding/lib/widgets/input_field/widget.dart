import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'resources.dart';

class InputField extends StatelessWidget {
  final String? hint;
  final String? initialValue;
  final Function(String)? onChanged;
  final Color? fillColor;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool isPassword;
  final TextInputType? keyboardType;

  const InputField(
      {Key? key,
      this.hint,
      required this.initialValue,
      this.onChanged,
      this.enabled = true,
      this.prefix,
      this.suffix,
      this.isPassword = false,
      this.fillColor,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      style: textField,
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      keyboardType: keyboardType,
      decoration: decTextField(
          hint: hint, prefix: prefix, suffix: suffix, fillColor: fillColor),
    );
  }
}
