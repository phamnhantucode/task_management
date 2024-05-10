// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingStateImpl _$$SettingStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingStateImpl(
      languageSelected:
          $enumDecodeNullable(_$LanguageEnumMap, json['languageSelected']) ??
              Language.english,
      themeSelected:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeSelected']) ??
              ThemeMode.light,
    );

Map<String, dynamic> _$$SettingStateImplToJson(_$SettingStateImpl instance) =>
    <String, dynamic>{
      'languageSelected': _$LanguageEnumMap[instance.languageSelected]!,
      'themeSelected': _$ThemeModeEnumMap[instance.themeSelected]!,
    };

const _$LanguageEnumMap = {
  Language.english: 'english',
  Language.vietnamese: 'vietnamese',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
