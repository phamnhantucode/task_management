import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_notification_dto.freezed.dart';
part 'firebase_notification_dto.g.dart';

@freezed
class FirebaseNotificationDto with _$FirebaseNotificationDto {
  factory FirebaseNotificationDto({
    required String to,
    required Map<String, dynamic> notification,
    required Map<String, dynamic> data
}) = _FirebaseNotificationDto;

    factory FirebaseNotificationDto.fromJson(Map<String, dynamic> json) => _$FirebaseNotificationDtoFromJson(json);
}

@freezed
class FireBaseNotificationInfo with _$FireBaseNotificationInfo {
  factory FireBaseNotificationInfo({
    required String title,
    required String body,
    @Default('notification_sound_1.mp3') String sound,
  }) = _FireBaseNotificationInfo;

    factory FireBaseNotificationInfo.fromJson(Map<String, dynamic> json) => _$FireBaseNotificationInfoFromJson(json);
}