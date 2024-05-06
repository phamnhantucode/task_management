import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

class TMElevatedButton extends StatelessWidget {
  const TMElevatedButton(
      {super.key,
      this.height,
      this.color,
      this.label,
      this.borderRadius,
      this.style,
      this.onPressed,
      this.textColor, this.decoration});

  final double? height;
  final Color? color;
  final Color? textColor;
  final String? label;
  final double? borderRadius;
  final TextStyle? style;
  final Function()? onPressed;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      width: double.infinity,
      height: height ?? 32,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(color),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8))),
          ),
          onPressed: onPressed,
          child: Text(
            label!,
            style: style?.copyWith(color: textColor) ??
                context.textTheme.labelSmall?.copyWith(color: textColor),
          )),
    );
  }
}
