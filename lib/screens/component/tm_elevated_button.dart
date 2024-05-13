import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';


class TMElevatedButton extends StatelessWidget {
  const TMElevatedButton({super.key,this.height, this.color, this.label, this.borderRadius, this.style, this.onPressed, this.textColor, this.decoration, this.leading, this.trailing,  this.isDisable = false});
  final double? height;
  final Color? color;
  final Color? textColor;
  final String? label;
  final double? borderRadius;
  final TextStyle? style;
  final Function()? onPressed;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisable;

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
          onPressed: isDisable ? null : onPressed,
          child: Row(
            children: [
              leading ?? const SizedBox.shrink(),
              Expanded(
                child: Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: style?.copyWith(color: textColor) ??
                      context.textTheme.labelSmall?.copyWith(color: textColor),
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          )),
    );
  }
}



