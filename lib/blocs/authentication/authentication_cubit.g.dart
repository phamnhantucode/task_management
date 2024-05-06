// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthenticationStateImpl _$$AuthenticationStateImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthenticationStateImpl(
      isAuthenticated: json['isAuthenticated'] as bool,
      expireTime: json['expireTime'] == null
          ? null
          : DateTime.parse(json['expireTime'] as String),
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$$AuthenticationStateImplToJson(
        _$AuthenticationStateImpl instance) =>
    <String, dynamic>{
      'isAuthenticated': instance.isAuthenticated,
      'expireTime': instance.expireTime?.toIso8601String(),
      'email': instance.email,
      'password': instance.password,
    };
