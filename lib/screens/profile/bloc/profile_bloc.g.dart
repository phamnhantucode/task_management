// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileStateImpl _$$ProfileStateImplFromJson(Map<String, dynamic> json) =>
    _$ProfileStateImpl(
      isTurnOnNotification: json['isTurnOnNotification'] as bool? ?? false,
      avatarPath: json['avatarPath'] as String?,
    );

Map<String, dynamic> _$$ProfileStateImplToJson(_$ProfileStateImpl instance) =>
    <String, dynamic>{
      'isTurnOnNotification': instance.isTurnOnNotification,
      'avatarPath': instance.avatarPath,
    };
