part of 'setting_cubit.dart';

@freezed
class SettingState with _$SettingState {
  const factory SettingState({
    @Default(Language.english) Language languageSelected,
    @Default(ThemeMode.light) ThemeMode themeSelected,
  }) = _SettingState;

  factory SettingState.fromJson(Map<String, dynamic> json) =>
      _$SettingStateFromJson(json);
}
