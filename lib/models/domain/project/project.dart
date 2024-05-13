import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;

import '../../dtos/project/project.dart';

part 'project.freezed.dart';
part "project.g.dart";

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required User owner,
    required String description,
    required DateTime startDate,
    required List<User> members,
    DateTime? endDate,
    required ProjectStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  factory Project.fromProjectDto(ProjectDto projectDto, User owner, List<User> members,) {
    return Project(
      id: projectDto.id,
      name: projectDto.name,
      owner: owner,
      description: projectDto.description,
      startDate: projectDto.startDate,
      members: members,
      endDate: projectDto.endDate,
      status: projectDto.status,
      createdAt: projectDto.createdAt,
      updatedAt: projectDto.updatedAt,
    );
  }
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String name,
    required String description,
    DateTime? startDate,
    DateTime? endDate,
    required TaskStatus status,
    required Project projectId,
    User? assignee,
    required User author,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  factory Task.fromTaskDto(TaskDto taskDto, Project project, User? assignee, User author) {
    return Task(
      id: taskDto.id,
      name: taskDto.name,
      description: taskDto.description,
      startDate: taskDto.startDate,
      endDate: taskDto.endDate,
      status: taskDto.status,
      projectId: project,
      assignee: assignee,
      author: author,
      createdAt: taskDto.createdAt,
      updatedAt: taskDto.updatedAt,
    );
  }
}

@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String fileName,
    required String filePath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  factory Attachment.fromAttachmentDto(AttachmentDto attachmentDto) {
    return Attachment(
      id: attachmentDto.id,
      fileName: attachmentDto.fileName,
      filePath: attachmentDto.filePath,
      createdAt: attachmentDto.createdAt,
      updatedAt: attachmentDto.updatedAt,
    );
  }
}