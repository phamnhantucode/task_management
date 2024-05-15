// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FriendDto _$FriendDtoFromJson(Map<String, dynamic> json) {
  return _FriendDto.fromJson(json);
}

/// @nodoc
mixin _$FriendDto {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  bool get isTargetAccepted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendDtoCopyWith<FriendDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendDtoCopyWith<$Res> {
  factory $FriendDtoCopyWith(FriendDto value, $Res Function(FriendDto) then) =
      _$FriendDtoCopyWithImpl<$Res, FriendDto>;
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String authorId,
      String targetId,
      bool isTargetAccepted});
}

/// @nodoc
class _$FriendDtoCopyWithImpl<$Res, $Val extends FriendDto>
    implements $FriendDtoCopyWith<$Res> {
  _$FriendDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? authorId = null,
    Object? targetId = null,
    Object? isTargetAccepted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      isTargetAccepted: null == isTargetAccepted
          ? _value.isTargetAccepted
          : isTargetAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendDtoImplCopyWith<$Res>
    implements $FriendDtoCopyWith<$Res> {
  factory _$$FriendDtoImplCopyWith(
          _$FriendDtoImpl value, $Res Function(_$FriendDtoImpl) then) =
      __$$FriendDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String authorId,
      String targetId,
      bool isTargetAccepted});
}

/// @nodoc
class __$$FriendDtoImplCopyWithImpl<$Res>
    extends _$FriendDtoCopyWithImpl<$Res, _$FriendDtoImpl>
    implements _$$FriendDtoImplCopyWith<$Res> {
  __$$FriendDtoImplCopyWithImpl(
      _$FriendDtoImpl _value, $Res Function(_$FriendDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? authorId = null,
    Object? targetId = null,
    Object? isTargetAccepted = null,
  }) {
    return _then(_$FriendDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      isTargetAccepted: null == isTargetAccepted
          ? _value.isTargetAccepted
          : isTargetAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendDtoImpl implements _FriendDto {
  _$FriendDtoImpl(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.authorId,
      required this.targetId,
      required this.isTargetAccepted});

  factory _$FriendDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendDtoImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String authorId;
  @override
  final String targetId;
  @override
  final bool isTargetAccepted;

  @override
  String toString() {
    return 'FriendDto(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, authorId: $authorId, targetId: $targetId, isTargetAccepted: $isTargetAccepted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.isTargetAccepted, isTargetAccepted) ||
                other.isTargetAccepted == isTargetAccepted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt,
      authorId, targetId, isTargetAccepted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendDtoImplCopyWith<_$FriendDtoImpl> get copyWith =>
      __$$FriendDtoImplCopyWithImpl<_$FriendDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendDtoImplToJson(
      this,
    );
  }
}

abstract class _FriendDto implements FriendDto {
  factory _FriendDto(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final String authorId,
      required final String targetId,
      required final bool isTargetAccepted}) = _$FriendDtoImpl;

  factory _FriendDto.fromJson(Map<String, dynamic> json) =
      _$FriendDtoImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get authorId;
  @override
  String get targetId;
  @override
  bool get isTargetAccepted;
  @override
  @JsonKey(ignore: true)
  _$$FriendDtoImplCopyWith<_$FriendDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
