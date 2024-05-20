import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/models/dtos/notification/action.dart';

import '../../dtos/notification/notification_dto.dart';
import '../../dtos/user/user_dto.dart';
import '../project/project.dart';

part 'notification.freezed.dart';

@freezed
class NotificationDm with _$NotificationDm {
  factory NotificationDm({
    required String id,
    required DateTime createdAt,
    required UserDto author,
    required String targetId,
    required UserDto userReceiveNotification,
    required ActionNotification action,
    required TargetType targetType,
    required String title,
    required String body,
    required bool isRead,
    required String? content,
  }) = _NotificationDm;

  factory NotificationDm.changeProjectName({
    required String id,
    required DateTime createdAt,
    required UserDto author,
    required String targetId,
    required UserDto userReceiveNotification,
    required ActionNotification action,
    required TargetType targetType,
    required String title,
    required String body,
    required bool isRead,
    required Project target,
    required String? content,
    required String newProjectName,
  }) = NotifyChangeProjectNameDm;

  factory NotificationDm.changeProjectDueDate({
    required String id,
    required DateTime createdAt,
    required UserDto author,
    required String targetId,
    required UserDto userReceiveNotification,
    required ActionNotification action,
    required TargetType targetType,
    required Project target,
    required String title,
    required String body,
    required bool isRead,
    required String? content,
    required DateTime newDueDate,
  }) = NotifyChangeProjectDueDateDm;

  static NotifyChangeProjectNameDm fromNotifyChangeProjectNameDto(
      NotifyChangeProjectNameDto dto,
      {required Project target,
      required UserDto author,
      required UserDto userReceiveNotification}) {
    return NotifyChangeProjectNameDm(
      id: dto.id,
      createdAt: dto.createdAt,
      author: author,
      content: dto.content,
      newProjectName: dto.newProjectName,
      targetId: dto.targetId,
      title: dto.title,
      body: dto.body,
      isRead: dto.isRead,
      action: dto.action,
      targetType: dto.targetType,
      userReceiveNotification: userReceiveNotification,
      target: target,
    );
  }

  static NotifyChangeProjectDueDateDm fromNotifyChangeProjectDueDateDto(
      NotifyChangeProjectDueDateDto dto,
      {required Project target,
      required UserDto author,
      required UserDto userReceiveNotification}) {
    return NotifyChangeProjectDueDateDm(
      id: dto.id,
      createdAt: dto.createdAt,
      author: author,
      content: dto.content,
      newDueDate: dto.newDueDate,
      targetId: dto.targetId,
      title: dto.title,
      body: dto.body,
      isRead: dto.isRead,
      action: dto.action,
      targetType: dto.targetType,
      userReceiveNotification: userReceiveNotification,
      target: target,
    );
  }

  //to NotifyChangeProjectDueDateDto, static function
  static NotifyChangeProjectDueDateDto toNotifyChangeProjectDueDateDto(
      NotifyChangeProjectDueDateDm dm) {
    return NotifyChangeProjectDueDateDto(
      id: dm.id,
      createdAt: dm.createdAt,
      authorId: dm.author.id,
      targetId: dm.targetId,
      userReceiveNotificationId: dm.userReceiveNotification.id,
      action: dm.action,
      targetType: dm.targetType,
      title: dm.title,
      body: dm.body,
      isRead: dm.isRead,
      content: dm.content,
      newDueDate: dm.newDueDate,
    );
  }

  //to NotifyChangeProjectNameDto
  static NotifyChangeProjectNameDto toNotifyChangeProjectNameDto(
      NotifyChangeProjectNameDm dm) {
    return NotifyChangeProjectNameDto(
      id: dm.id,
      createdAt: dm.createdAt,
      authorId: dm.author.id,
      targetId: dm.targetId,
      userReceiveNotificationId: dm.userReceiveNotification.id,
      action: dm.action,
      targetType: dm.targetType,
      title: dm.title,
      body: dm.body,
      isRead: dm.isRead,
      content: dm.content,
      newProjectName: dm.newProjectName,
    );
  }

  static Future<NotificationDm> fromNotificationDto(NotificationDto notificationDto) async {
    final author = await UsersRepository.instance.getUserById(notificationDto.authorId);
    final userReceiveNotification = await UsersRepository.instance.getUserById(notificationDto.userReceiveNotificationId);
    if (author == null || userReceiveNotification == null) {
      throw Exception('Author or userReceiveNotification not found');
    }
    switch (notificationDto.action) {
      case ActionNotification.changeProjectName:
        final project = await ProjectRepository.instance.getProject(notificationDto.targetId);
        if (project == null) {
          throw Exception('Project not found');
        }
        return NotificationDm.fromNotifyChangeProjectNameDto(notificationDto as NotifyChangeProjectNameDto, target: project, author: author, userReceiveNotification: userReceiveNotification);
      case ActionNotification.inviteToProject:
        // TODO: Handle this case.
      case ActionNotification.acceptRequestToProject:
        // TODO: Handle this case.
      case ActionNotification.assignInTask:
        // TODO: Handle this case.
      case ActionNotification.addNote:
        // TODO: Handle this case.
      case ActionNotification.submitTask:
        // TODO: Handle this case.
      case ActionNotification.changeStatusTask:
        // TODO: Handle this case.
      case ActionNotification.changeStatusProject:
        // TODO: Handle this case.
      case ActionNotification.changeStatusRequest:
        // TODO: Handle this case.
      case ActionNotification.removeFromProject:
        // TODO: Handle this case.
      case ActionNotification.removeTask:
        // TODO: Handle this case.
      case ActionNotification.changeDueDateTask:
        // TODO: Handle this case.
      case ActionNotification.changeDueDateProject:
        // TODO: Handle this case.
    }
    throw Exception('Action not found');
  }

}
