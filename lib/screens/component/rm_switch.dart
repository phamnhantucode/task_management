import 'package:flutter/material.dart';

class RMSwitch extends StatelessWidget {
  const RMSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.height,
    this.width,
  });

  final bool value;
  final void Function(bool value)? onChanged;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 30,
      width: width ?? 40,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: value,
          activeColor: Colors.blue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}