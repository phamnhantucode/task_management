import 'package:flutter/material.dart';

class TMElevatedButton extends StatelessWidget {
  const TMElevatedButton({super.key,this.height, this.color, this.label, this.borderRadius, this.style, this.onPressed});
  final double? height;
  final Color? color;
  final String? label;
  final double? borderRadius;
  final TextStyle? style;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(color),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius!))),
        ),
        onPressed:  onPressed,
        child: Text(
         label!,
         style: style,
        )
      ),
    );
  }
}



