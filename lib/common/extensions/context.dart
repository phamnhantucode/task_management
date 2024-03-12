import 'package:flutter/material.dart';
import 'package:room_master_app/app/app.dart';

import '../../theme/app_colors.dart';

extension BuildContextX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  AppColorsScheme get appColors => AppView.of(this).appColors.scheme;
}
