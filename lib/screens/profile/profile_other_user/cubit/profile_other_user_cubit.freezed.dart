// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_other_user_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileOtherUserState {
  FriendState get friendState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileOtherUserStateCopyWith<ProfileOtherUserState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileOtherUserStateCopyWith<$Res> {
  factory $ProfileOtherUserStateCopyWith(ProfileOtherUserState value,
          $Res Function(ProfileOtherUserState) then) =
      _$ProfileOtherUserStateCopyWithImpl<$Res, ProfileOtherUserState>;
  @useResult
  $Res call({FriendState friendState});
}

/// @nodoc
class _$ProfileOtherUserStateCopyWithImpl<$Res,
        $Val extends ProfileOtherUserState>
    implements $ProfileOtherUserStateCopyWith<$Res> {
  _$ProfileOtherUserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendState = null,
  }) {
    return _then(_value.copyWith(
      friendState: null == friendState
          ? _value.friendState
          : friendState // ignore: cast_nullable_to_non_nullable
              as FriendState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileOtherUserStateImplCopyWith<$Res>
    implements $ProfileOtherUserStateCopyWith<$Res> {
  factory _$$ProfileOtherUserStateImplCopyWith(
          _$ProfileOtherUserStateImpl value,
          $Res Function(_$ProfileOtherUserStateImpl) then) =
      __$$ProfileOtherUserStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FriendState friendState});
}

/// @nodoc
class __$$ProfileOtherUserStateImplCopyWithImpl<$Res>
    extends _$ProfileOtherUserStateCopyWithImpl<$Res,
        _$ProfileOtherUserStateImpl>
    implements _$$ProfileOtherUserStateImplCopyWith<$Res> {
  __$$ProfileOtherUserStateImplCopyWithImpl(_$ProfileOtherUserStateImpl _value,
      $Res Function(_$ProfileOtherUserStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendState = null,
  }) {
    return _then(_$ProfileOtherUserStateImpl(
      friendState: null == friendState
          ? _value.friendState
          : friendState // ignore: cast_nullable_to_non_nullable
              as FriendState,
    ));
  }
}

/// @nodoc

class _$ProfileOtherUserStateImpl implements _ProfileOtherUserState {
  const _$ProfileOtherUserStateImpl({this.friendState = FriendState.loading});

  @override
  @JsonKey()
  final FriendState friendState;

  @override
  String toString() {
    return 'ProfileOtherUserState(friendState: $friendState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileOtherUserStateImpl &&
            (identical(other.friendState, friendState) ||
                other.friendState == friendState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, friendState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileOtherUserStateImplCopyWith<_$ProfileOtherUserStateImpl>
      get copyWith => __$$ProfileOtherUserStateImplCopyWithImpl<
          _$ProfileOtherUserStateImpl>(this, _$identity);
}

abstract class _ProfileOtherUserState implements ProfileOtherUserState {
  const factory _ProfileOtherUserState({final FriendState friendState}) =
      _$ProfileOtherUserStateImpl;

  @override
  FriendState get friendState;
  @override
  @JsonKey(ignore: true)
  _$$ProfileOtherUserStateImplCopyWith<_$ProfileOtherUserStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
