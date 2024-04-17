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
    this.obscureText = false, this.suffixIcon,
  });

  final String? initialText;
  final String? hintText;
  final TextStyle? textStyle;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyBoardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.appColors.textWhite)),
      padding: EdgeInsetsDirectional.only(start: 16.w),
      child: TextFormField(
        scrollPadding: EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
        obscureText: obscureText,
        initialValue: initialText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: context.textTheme.bodyMedium
              ?.copyWith(color: context.appColors.textGray),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        maxLines: maxLines,
        style: textStyle,
        keyboardType: keyBoardType,
      ),
    );
  }
}
