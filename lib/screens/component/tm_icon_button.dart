import 'package:flutter/material.dart';

class TMIconButton extends StatelessWidget {
  final Widget icon;
  final double size;
  final Color color;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final BoxDecoration decoration;

  const TMIconButton({super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.padding,
    this.decoration = const BoxDecoration(
      shape: BoxShape.circle,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration.copyWith(color: backgroundColor),
      child: IconButton(
        icon: icon,
        color: color,
        iconSize: size,
        onPressed: onPressed,
      ),
    );
  }
}