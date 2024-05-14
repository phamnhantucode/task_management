import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/project/project.dart';

part 'project.freezed.dart';
part 'project.g.dart';

enum ProjectStatus { notStarted, inProgress, completed }

@freezed
class ProjectDto with _$ProjectDto {
  const factory ProjectDto({
    required String id,
    required String name,
    required String ownerId,
    required String description,
    required DateTime startDate,
    required List<String> membersId,
    DateTime? endDate,
    required ProjectStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectDto;

  factory ProjectDto.fromJson(Map<String, dynamic> json) => _$ProjectDtoFromJson(json);
  factory ProjectDto.fromProject(Project project) {
    return ProjectDto(
      id: project.id,
      name: project.name,
      ownerId: project.owner.id,
      description: project.description,
      startDate: project.startDate,
      membersId: project.members.map((e) => e.id).toList(),
      endDate: project.endDate,
      status: project.status,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
  }
}

enum TaskStatus { notStarted, inProgress, completed }

@freezed
class TaskDto with _$TaskDto {
  const factory TaskDto({
    required String id,
    required String name,
    required String description,
    DateTime? startDate,
    DateTime? endDate,
    required TaskStatus status,
    required String projectId,
    String? assigneeId,
    required String authorId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);
}

@freezed
class AttachmentDto with _$AttachmentDto {
  const factory AttachmentDto({
    required String id,
    required String fileName,
    required String filePath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AttachmentDto;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) => _$AttachmentDtoFromJson(json);
}