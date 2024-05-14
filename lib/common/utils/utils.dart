// ignore_for_file: unnecessary_string_escapes
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:intl/intl.dart';
import 'package:json_path/json_path.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../app/app.dart';

void _setTimeAgoLocales() {
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
}

DateTime get getCurrentTimestamp => DateTime.now();

extension DateTimeComparisonOperators on DateTime {
  bool operator <(DateTime other) => isBefore(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator <=(DateTime other) => this < other || isAtSameMomentAs(other);
  bool operator >=(DateTime other) => this > other || isAtSameMomentAs(other);
}

bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isiOS => !kIsWeb && Platform.isIOS;
bool get isWeb => kIsWeb;

void setDarkModeSetting(BuildContext context, ThemeMode themeMode) =>
    AppView.of(context).setThemeMode(themeMode);

void showSnackbar(
    BuildContext context,
    String message, {
      bool loading = false,
      int duration = 4,
    }) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

Color getBackgroundColor(int current, int max) {
  final percentage = current / max;
  if (percentage < 0.3) {
    return Colors.redAccent;
  } else if (percentage < 0.6) {
    return Colors.orangeAccent;
  } else {
    return Colors.green.shade400;
  }
}

Color getContrastColor(Color color) {
  double brightness = color.red * 0.2126 + color.green * 0.7152 + color.blue * 0.0772;
  return brightness > 200 ? Colors.black : Colors.white;
}