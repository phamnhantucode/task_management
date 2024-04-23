import 'package:flutter/material.dart';

class SpacerComponent extends StatelessWidget {
  final String size;
  final bool isVerical;

  const SpacerComponent({super.key, required this.size, this.isVerical = true});
  @override
  Widget build(BuildContext context) {
    double space = size == 'l'
        ? 20
        : size == 'm'
            ? 14
            : 8;
    if (isVerical) {
      return SizedBox(
        height: space,
      );
    } else {
      return SizedBox(
        width: space,
      );
    }
  }
}
