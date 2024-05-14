import 'package:flutter/material.dart';

class TMIconButton extends StatelessWidget {
  final Widget icon;
  final double size;
  final Color color;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final BoxDecoration decoration;
  final double? width;
  final double? height;

  const TMIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.padding,
    this.decoration = const BoxDecoration(
      shape: BoxShape.circle,
    ),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration.copyWith(color: backgroundColor),
      child: IconButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
        ),
        icon: icon,
        color: color,
        iconSize: size,
        onPressed: onPressed,
      ),
    );
  }
}
