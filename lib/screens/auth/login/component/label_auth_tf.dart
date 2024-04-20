import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

class LabelAuth extends StatelessWidget {
  const LabelAuth({super.key, required this.title, this.textStyle, this.labelAuth, this.color, this.onPress, });
  final String? title;
  final String? labelAuth;
  final TextStyle? textStyle;
  final Color? color;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title!,
            style: context.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: onPress,
            style:  TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(
                labelAuth!,
                style: textStyle
            ),
          ),
        ],
      ),
    );
  }
}
