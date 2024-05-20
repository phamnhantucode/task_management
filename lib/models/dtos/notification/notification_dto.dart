import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/models/dtos/notification/action.dart';

import '../../domain/notification/notification.dart';

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
    required String title,
    required String body,
    required bool isRead,
    required String? content,
  }) = _NotificationDto;

  factory NotificationDto.changeProjectName({
    required String id,
    required DateTime createdAt,
    required String authorId,
    required String targetId,
    required String userReceiveNotificationId,
    required ActionNotification action,
    required TargetType targetType,
    required String title,
    required String body,
    required bool isRead,
    required String? content,
    required String newProjectName,
  }) = NotifyChangeProjectNameDto;

  factory NotificationDto.changeProjectDueDate({
    required String id,
    required DateTime createdAt,
    required String authorId,
    required String targetId,
    required String userReceiveNotificationId,
    required ActionNotification action,
    required TargetType targetType,
    required String title,
    required String body,
    required bool isRead,
    required String? content,
    required DateTime newDueDate,
  }) = NotifyChangeProjectDueDateDto;

  factory NotificationDto.fromNotificationDm(NotificationDm notification) =>
      NotificationDto(
        id: notification.id,
        createdAt: notification.createdAt,
        authorId: notification.author.id,
        targetId: notification.targetId,
        userReceiveNotificationId: notification.userReceiveNotification.id,
        action: notification.action,
        targetType: notification.targetType,
        title: notification.title,
        body: notification.body,
        isRead: notification.isRead,
        content: notification.content,
      );

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
}
