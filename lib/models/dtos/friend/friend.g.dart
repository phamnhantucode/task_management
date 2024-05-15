// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendDtoImpl _$$FriendDtoImplFromJson(Map<String, dynamic> json) =>
    _$FriendDtoImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      authorId: json['authorId'] as String,
      targetId: json['targetId'] as String,
      isTargetAccepted: json['isTargetAccepted'] as bool,
    );

Map<String, dynamic> _$$FriendDtoImplToJson(_$FriendDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'authorId': instance.authorId,
      'targetId': instance.targetId,
      'isTargetAccepted': instance.isTargetAccepted,
    };
