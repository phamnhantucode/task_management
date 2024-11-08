import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

final class TMTextField extends StatelessWidget {
  const TMTextField({
    super.key,
    this.initialText,
    this.hintText,
    this.textStyle,
    this.maxLines,
    this.prefixIcon,
    this.keyBoardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onTextChange,
    this.controller,
    this.borderColor,
    this.validator,
    this.keys,
    this.keyboardType,
    this.errorText,
    this.autoFocus = false,
    this.contentPadding, this.minLines,
  });

  final String? initialText;
  final Key? keys;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextStyle? textStyle;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyBoardType;
  final bool obscureText;
  final void Function(String content)? onTextChange;
  final FormFieldValidator? validator;
  final String? errorText;
  final TextEditingController? controller;
  final Color? borderColor;
  final bool autoFocus;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      scrollPadding:
          EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
      obscureText: obscureText,
      initialValue: controller == null ? initialText : null,
      onChanged: (value) {
        if (onTextChange != null) {
          onTextChange!(value);
        }
      },
      decoration: InputDecoration(
          contentPadding: contentPadding ?? const EdgeInsets.all(12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: borderColor ?? context.appColors.textWhite)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                  color: borderColor ?? context.appColors.textWhite)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                  color: borderColor ?? context.appColors.textWhite)),
          hintText: hintText,
          hintStyle: context.textTheme.bodyMedium
              ?.copyWith(color: context.appColors.textGray),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          errorText: errorText),
      maxLines: maxLines,
      minLines: minLines,
      style: textStyle,
      keyboardType: keyBoardType,
      validator: validator,
    );
  }
}
