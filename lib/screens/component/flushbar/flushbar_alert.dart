import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

void showAlertFlushBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 3),
    backgroundColor: CupertinoColors.systemOrange.withOpacity(0.8),
     flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}