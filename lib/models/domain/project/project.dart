import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../dtos/project/project.dart';
import '../../dtos/user/user_dto.dart';

part 'project.freezed.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required UserDto owner,
    required String description,
    required DateTime startDate,
    required List<UserDto> members,
    DateTime? endDate,
    required ProjectStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Color color,
  }) = _Project;

  factory Project.fromProjectDto(ProjectDto projectDto, UserDto owner, List<UserDto> members,) {
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
      updatedAt: projectDto.updatedAt, color: projectDto.color == null ? Colors.blue.shade200 : Color(projectDto.color!),
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
    required List<UserDto> assignees,
    required UserDto author,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromTaskDto(TaskDto taskDto, Project project, List<UserDto?> assignees, UserDto author) {
    return Task(
      id: taskDto.id,
      name: taskDto.name,
      description: taskDto.description,
      startDate: taskDto.startDate,
      endDate: taskDto.endDate,
      status: taskDto.status,
      projectId: project,
      assignees: assignees.where((element) => element != null).toList().cast<UserDto>(),
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

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String content,
    required Task task,
    required UserDto author,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Comment;

  factory Comment.fromCommentDto(CommentDto commentDto, Task task, UserDto author) {
    return Comment(
      id: commentDto.id,
      content: commentDto.content,
      task: task,
      author: author,
      createdAt: commentDto.createdAt,
      updatedAt: commentDto.updatedAt,
    );
  }
}

@freezed
class Notes with _$Notes {
  const factory Notes({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Notes;

  factory Notes.fromNotesDto(NotesDto notesDto,) {
    return Notes(
      id: notesDto.id,
      content: notesDto.content,
      createdAt: notesDto.createdAt,
      updatedAt: notesDto.updatedAt,
    );
  }
}