// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingState _$SettingStateFromJson(Map<String, dynamic> json) {
  return _SettingState.fromJson(json);
}

/// @nodoc
mixin _$SettingState {
  Language get languageSelected => throw _privateConstructorUsedError;
  ThemeMode get themeSelected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingStateCopyWith<SettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingStateCopyWith<$Res> {
  factory $SettingStateCopyWith(
          SettingState value, $Res Function(SettingState) then) =
      _$SettingStateCopyWithImpl<$Res, SettingState>;
  @useResult
  $Res call({Language languageSelected, ThemeMode themeSelected});
}

/// @nodoc
class _$SettingStateCopyWithImpl<$Res, $Val extends SettingState>
    implements $SettingStateCopyWith<$Res> {
  _$SettingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageSelected = null,
    Object? themeSelected = null,
  }) {
    return _then(_value.copyWith(
      languageSelected: null == languageSelected
          ? _value.languageSelected
          : languageSelected // ignore: cast_nullable_to_non_nullable
              as Language,
      themeSelected: null == themeSelected
          ? _value.themeSelected
          : themeSelected // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingStateImplCopyWith<$Res>
    implements $SettingStateCopyWith<$Res> {
  factory _$$SettingStateImplCopyWith(
          _$SettingStateImpl value, $Res Function(_$SettingStateImpl) then) =
      __$$SettingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Language languageSelected, ThemeMode themeSelected});
}

/// @nodoc
class __$$SettingStateImplCopyWithImpl<$Res>
    extends _$SettingStateCopyWithImpl<$Res, _$SettingStateImpl>
    implements _$$SettingStateImplCopyWith<$Res> {
  __$$SettingStateImplCopyWithImpl(
      _$SettingStateImpl _value, $Res Function(_$SettingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageSelected = null,
    Object? themeSelected = null,
  }) {
    return _then(_$SettingStateImpl(
      languageSelected: null == languageSelected
          ? _value.languageSelected
          : languageSelected // ignore: cast_nullable_to_non_nullable
              as Language,
      themeSelected: null == themeSelected
          ? _value.themeSelected
          : themeSelected // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingStateImpl implements _SettingState {
  const _$SettingStateImpl(
      {this.languageSelected = Language.english,
      this.themeSelected = ThemeMode.light});

  factory _$SettingStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingStateImplFromJson(json);

  @override
  @JsonKey()
  final Language languageSelected;
  @override
  @JsonKey()
  final ThemeMode themeSelected;

  @override
  String toString() {
    return 'SettingState(languageSelected: $languageSelected, themeSelected: $themeSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingStateImpl &&
            (identical(other.languageSelected, languageSelected) ||
                other.languageSelected == languageSelected) &&
            (identical(other.themeSelected, themeSelected) ||
                other.themeSelected == themeSelected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, languageSelected, themeSelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingStateImplCopyWith<_$SettingStateImpl> get copyWith =>
      __$$SettingStateImplCopyWithImpl<_$SettingStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingStateImplToJson(
      this,
    );
  }
}

abstract class _SettingState implements SettingState {
  const factory _SettingState(
      {final Language languageSelected,
      final ThemeMode themeSelected}) = _$SettingStateImpl;

  factory _SettingState.fromJson(Map<String, dynamic> json) =
      _$SettingStateImpl.fromJson;

  @override
  Language get languageSelected;
  @override
  ThemeMode get themeSelected;
  @override
  @JsonKey(ignore: true)
  _$$SettingStateImplCopyWith<_$SettingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
