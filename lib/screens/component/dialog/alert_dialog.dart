import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';

Future<T?> showAlertDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required void Function() rightAction,
  void Function()? leftAction,
}) async {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: context.textTheme.titleSmall,),
        content: Text(content, style: context.textTheme.bodyMedium,),
        actions: [
          TextButton(
              onPressed: rightAction,
              child: Text(context.l10n.text_ok, style: context.textTheme.labelMedium,)),
          if (leftAction != null)
            TextButton(
                onPressed: leftAction,
                child: Text(context.l10n.text_cancel, style: context.textTheme.labelMedium,))
        ],
      );
    },
  );
}
