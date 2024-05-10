// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileState _$ProfileStateFromJson(Map<String, dynamic> json) {
  return _ProfileState.fromJson(json);
}

/// @nodoc
mixin _$ProfileState {
  bool get isTurnOnNotification => throw _privateConstructorUsedError;
  String? get avatarPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call({bool isTurnOnNotification, String? avatarPath});
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isTurnOnNotification = null,
    Object? avatarPath = freezed,
  }) {
    return _then(_value.copyWith(
      isTurnOnNotification: null == isTurnOnNotification
          ? _value.isTurnOnNotification
          : isTurnOnNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileStateImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateImplCopyWith(
          _$ProfileStateImpl value, $Res Function(_$ProfileStateImpl) then) =
      __$$ProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isTurnOnNotification, String? avatarPath});
}

/// @nodoc
class __$$ProfileStateImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateImpl>
    implements _$$ProfileStateImplCopyWith<$Res> {
  __$$ProfileStateImplCopyWithImpl(
      _$ProfileStateImpl _value, $Res Function(_$ProfileStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isTurnOnNotification = null,
    Object? avatarPath = freezed,
  }) {
    return _then(_$ProfileStateImpl(
      isTurnOnNotification: null == isTurnOnNotification
          ? _value.isTurnOnNotification
          : isTurnOnNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileStateImpl implements _ProfileState {
  const _$ProfileStateImpl(
      {this.isTurnOnNotification = false, this.avatarPath});

  factory _$ProfileStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isTurnOnNotification;
  @override
  final String? avatarPath;

  @override
  String toString() {
    return 'ProfileState(isTurnOnNotification: $isTurnOnNotification, avatarPath: $avatarPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateImpl &&
            (identical(other.isTurnOnNotification, isTurnOnNotification) ||
                other.isTurnOnNotification == isTurnOnNotification) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isTurnOnNotification, avatarPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      __$$ProfileStateImplCopyWithImpl<_$ProfileStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileStateImplToJson(
      this,
    );
  }
}

abstract class _ProfileState implements ProfileState {
  const factory _ProfileState(
      {final bool isTurnOnNotification,
      final String? avatarPath}) = _$ProfileStateImpl;

  factory _ProfileState.fromJson(Map<String, dynamic> json) =
      _$ProfileStateImpl.fromJson;

  @override
  bool get isTurnOnNotification;
  @override
  String? get avatarPath;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
