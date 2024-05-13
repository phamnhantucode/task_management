import 'package:flutter/material.dart';

class SpacerComponent extends StatelessWidget {
  final double space;
  final bool isVertical;

  const SpacerComponent._({Key? key, required this.space, this.isVertical = true}) : super(key: key);

  factory SpacerComponent.l({bool isVertical = true}) => SpacerComponent._(space: 20, isVertical: isVertical);
  factory SpacerComponent.m({bool isVertical = true}) => SpacerComponent._(space: 14, isVertical: isVertical);
  factory SpacerComponent.s({bool isVertical = true}) => SpacerComponent._(space: 8, isVertical: isVertical);

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
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