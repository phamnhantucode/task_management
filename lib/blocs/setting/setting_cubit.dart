import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../common/app_setting.dart';
import '../../theme/app_colors.dart';

part 'setting_state.dart';
part 'setting_cubit.freezed.dart';
part 'setting_cubit.g.dart';

class SettingCubit extends HydratedCubit<SettingState> {
  SettingCubit() : super(const SettingState());

  void setThemeMode(ThemeMode type) {
    emit(state.copyWith(themeSelected: type));
  }

  void setLanguage(Language language) {
    emit(state.copyWith(languageSelected: language));
  }

  @override
  SettingState? fromJson(Map<String, dynamic> json) {
    return SettingState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingState state) {
    return state.toJson();
  }
}
