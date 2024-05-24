import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/main.dart';
import 'package:room_master_app/models/domain/project/project.dart';
import 'package:room_master_app/models/dtos/project/project.dart';
import 'package:path/path.dart' as path;

import '../../../domain/service/cloud_storage_service.dart';
import '../../../domain/service/file_picker_service.dart';
import '../../../models/dtos/user/user_dto.dart';
import '../../../models/enum/image_picker_type.dart';

part 'task_detail_cubit.freezed.dart';
part 'task_detail_state.dart';

class TaskDetailCubit extends Cubit<TaskDetailInfoState> {
  TaskDetailCubit() : super(const TaskDetailInfoState());

  late StreamSubscription _commentSubscription;
  late StreamSubscription _taskSubscription;
  late String _projectId;
  late String _taskId;

  void init(String projectId, String taskId) {
    _projectId = projectId;
    _taskId = taskId;
    _taskSubscription = ProjectRepository.instance
        .getTaskDetailStream(projectId, taskId)
        .listen((task) {
      emit(state.copyWith(
        taskName: task.name,
        project: task.projectId,
        description: task.description,
        status: task.status,
        assignees: task.assignees,
        startDate: task.startDate,
        endDate: task.endDate,
      ));
        });
    _commentSubscription = ProjectRepository.instance
        .getCommentStream(projectId, taskId)
        .listen((comments) {
      emit(state.copyWith(comments: comments..sort((a, b) => b.createdAt.compareTo(a.createdAt))));
    });
  }

  void assignTaskFor(UserDto user, bool isCurrentAdded) {
    // if (isCurrentAdded) {
    //   emit(state.copyWith(assignee: null));
    // } else {
    //   emit(state.copyWith(assignee: user));
    // }
  }

  void onChangeComment(String content) {
    emit(state.copyWith(comment: content));
  }

  void addComment(
      {required String userId,
      required String taskId,
      required String projectId}) async {


    final commentDto = CommentDto(
      content: state.comment,
      taskId: taskId,
      id: uuid.v1(),
      authorId: userId,
      createdAt: getCurrentTimestamp,
      updatedAt: getCurrentTimestamp,
      attachmentIds: [],
    );

    await ProjectRepository.instance.addComment(projectId, taskId, commentDto);

    Future.forEach(state.attachmentPaths, (element) async{
      final downloadPath =
      await CloudStorageService.instance.uploadFile(element);
      if (downloadPath != null) {
        addAttachmentInComment(
            fileName: path.basename(element), downloadUrl: downloadPath, commentId: commentDto.id, taskId: taskId, projectId: projectId);
      }
    });

    emit(state.copyWith(comment: '', attachmentPaths: []));
  }

  void handleImageSelection(String imagePath) async {
    emit(state.copyWith(attachmentPaths: state.attachmentPaths + [imagePath]));
  }

  void handleFileSelection(String filePath) async {
    emit(state.copyWith(attachmentPaths: state.attachmentPaths + [filePath]));
  }

  void addAttachmentInComment({required String fileName, required String downloadUrl, required String commentId, required String taskId, required String projectId}) {
    ProjectRepository.instance.addAttachmentToComment(projectId, taskId, commentId, AttachmentDto(
        id: uuid.v1(),
        fileName: fileName,
        filePath: downloadUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ));
  }

  void changeTaskStatus(TaskStatus status) async{
    addCommentWithMessage(
      userId: FirebaseAuth.instance.currentUser!.uid,
      taskId: _taskId,
      projectId: _projectId,
      message: 'Change task status to ${status.toString().split('.').last}',
    ).then((value) =>
        ProjectRepository.instance.updateTaskStatus(
          taskId: _taskId,
          projectId: _projectId,
          status: status,
        ));
  }

  @override
  Future<void> close() {
    _commentSubscription.cancel();
    _taskSubscription.cancel();
    return super.close();
  }

  void removeAttachment(String imageAttachment) {
    emit(state.copyWith(attachmentPaths: state.attachmentPaths.where((element) => element != imageAttachment).toList()));
  }

  Future<void> addCommentWithMessage({required String userId,
  required String taskId,
  required String projectId,required String message})async{
    final commentDto = CommentDto(
      content: message,
      taskId: taskId,
      id: uuid.v1(),
      authorId: userId,
      createdAt: getCurrentTimestamp,
      updatedAt: getCurrentTimestamp,
      attachmentIds: [],
    );

    return ProjectRepository.instance.addComment(projectId, taskId, commentDto);
  }
}
