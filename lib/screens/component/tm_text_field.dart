import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';

final class TMTextField extends StatelessWidget {
  const TMTextField({
    super.key,
    this.initialText,
    this.hintText,
    this.textStyle,
    this.maxLines = 1,
    this.prefixIcon,
    this.keyBoardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onTextChange,
    this.validator,
    this.controller,  this.keys, this.keyboardType, this.errorText,
  });

  final String? initialText;
  final  Key? keys;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextStyle? textStyle;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyBoardType;
  final bool obscureText;
  final void Function(String content)? onTextChange;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding:
          EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
      obscureText: obscureText,
      initialValue: initialText,
      onChanged: onTextChange,
      
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: context.appColors.textWhite)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: context.appColors.textWhite)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: context.appColors.textWhite)
        ),
    
        hintText: hintText,
        hintStyle: context.textTheme.bodyMedium
            ?.copyWith(color: context.appColors.textGray),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText
      ),
      maxLines: maxLines,
      style: textStyle,
      keyboardType: keyBoardType,
      validator: validator,
    );
  }
}
