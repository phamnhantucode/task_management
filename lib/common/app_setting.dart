import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_master_app/l10n/l10n.dart';

import 'assets/app_assets.dart';

class AppSetting {}

enum Language {
  english,
  vietnamese;

  String getLocalizationText(BuildContext context) {
    return switch (this) {
      Language.english => context.l10n.text_vietnamese,
      Language.vietnamese => context.l10n.text_english,
    };
  }

  String getAssetPathIconLanguage() {
    return switch (this) {
      Language.english => AppAssets.iconEnglishFlag,
      Language.vietnamese => AppAssets.iconVietnamFlag,
    };
  }
}

extension ThemeModeX on ThemeMode {
  String getLocalizationText(BuildContext context) {
    return switch (this) {
      ThemeMode.light => context.l10n.text_light,
      ThemeMode.dark => context.l10n.text_dark,
      ThemeMode.system => context.l10n.text_system,
    };
  }
}
