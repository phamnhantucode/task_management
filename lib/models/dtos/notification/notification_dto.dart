import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/models/dtos/notification/action.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

@freezed
class NotificationDto with _$NotificationDto {
  factory NotificationDto({
    required String id,
    required DateTime createdAt,
    required String authorId,
    required String targetId,
    required String userReceiveNotificationId,
    required ActionNotification action,
    required TargetType targetType,
    required bool isRead,
    String? content,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) => _$NotificationDtoFromJson(json);
}