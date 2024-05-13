
import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

Future<T?> showAuthDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required Color colorTitle,
  required Color colorContent,
  required void Function() rightAction,
  void Function()? leftAction,
  required String titleButton
}) async {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(child: Text(title, style: context.textTheme.titleMedium?.copyWith(color: colorTitle))),
        content: Text(content, style: context.textTheme.bodyMedium?.copyWith(color: colorContent)),
        actions: [
          TextButton(
              onPressed: rightAction,
            style: TextButton.styleFrom(
             backgroundColor: context.appColors.buttonDisable,
            ),
              child: Text(titleButton, style: context.textTheme.labelMedium  ?.copyWith(color: context.appColors.buttonEnable),),

          ),
          if (leftAction != null)
            TextButton(
                onPressed: leftAction,
                child: Text(titleButton, style: context.textTheme.labelMedium,))
        ],
      );
    },
  );
}