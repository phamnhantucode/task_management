import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;

import '../../domain/repositories/project/project_repository.dart';
import '../../main.dart';
import '../../models/domain/project/project.dart';
import '../../models/dtos/project/project.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;
part 'project_detail_cubit.freezed.dart';
part 'project_detail_state.dart';

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  ProjectDetailCubit() : super(const ProjectDetailState());

  late StreamSubscription<Project> projectSubscription;
  late StreamSubscription<List<Task>> tasksSubscription;
  late StreamSubscription<List<Attachment>> attachmentsSubscription;
  late StreamSubscription<double> progressSubscription;

  void init(String projectId) async {
    projectSubscription = ProjectRepository.instance
        .getProjectStream(projectId)
        .listen((project) {
      emit(state.copyWith(
          project: project,
          projectName: project.name,
          members: project.members,
          projectDescription: project.description,
          startDate: project.startDate,
          endDate: project.endDate));
    });
    tasksSubscription = ProjectRepository.instance
        .getTasksFromProjectStream(projectId)
        .listen((tasks) {
      emit(state.copyWith(tasks: tasks, tasksCopy: tasks));
    });
    attachmentsSubscription = ProjectRepository.instance
        .getAttachmentsFromProjectStream(projectId)
        .listen((attachments) {
      emit(state.copyWith(attachments: attachments));
    });
    progressSubscription = ProjectRepository.instance
        .getProjectProgress(projectId)
        .listen((progress) {
      emit(state.copyWith(progress: progress));
    });
  }

  @override
  Future<void> close() {
    projectSubscription.cancel();
    tasksSubscription.cancel();
    attachmentsSubscription.cancel();
    return super.close();
  }

  void updateProjectName(String value) {
    emit(state.copyWith(projectName: value));
  }

  void updateProject() {
    ProjectRepository.instance.updateProject(ProjectDto.fromProject(
        state.project!.copyWith(
            name: state.projectName,
            description: state.projectDescription,
            members: state.members,
            startDate: state.startDate!,
            endDate: state.endDate)));
    if (state.tasks.length != state.tasksCopy.length) {
      for (var task in state.tasks) {
        if (!state.tasksCopy.contains(task)) {
          ProjectRepository.instance
              .deleteTaskFromProject(task.id, state.project!.id);
        }
      }
    }
  }

  void updateStartDate(DateTime value) {
    emit(state.copyWith(startDate: value));
  }

  void updateEndDate(DateTime value) {
    emit(state.copyWith(endDate: value));
  }

  void updateProjectDescription(String value) {
    emit(state.copyWith(projectDescription: value));
  }

  void updateMembers(User user, bool isCurrentAdded) {
    if (isCurrentAdded) {
      List<User> listTmp = List.from(state.members);
      listTmp.removeWhere((element) => element.id == user.id);
      emit(state.copyWith(members: listTmp));
    } else {
      emit(state.copyWith(members: [...state.members, user]));
    }
  }

  void cancelUpdateProject() {
    if (state.project != null) {
      emit(state.copyWith(
        projectName: state.project!.name,
        projectDescription: state.project!.description,
        startDate: state.project!.startDate,
        endDate: state.project!.endDate,
        tasksCopy: state.tasks,
      ));
    }
  }

  void deleteTask(String taskId) {
    // ProjectRepository.instance.deleteTaskFromProject(taskId, state.project?.id ?? '');
    emit(state.copyWith(
        tasksCopy:
            state.tasksCopy.where((task) => task.id != taskId).toList()));
  }

  void addAttachment({required String fileName, required String downloadUrl}) {
    ProjectRepository.instance.addAttachmentToProject(
        state.project!.id,
        AttachmentDto(
            id: uuid.v1(),
            fileName: fileName,
            filePath: downloadUrl,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()));
  }

  void removeAttachment(Attachment attachment) {
    ProjectRepository.instance.deleteAttachmentFromProject(
      state.project!.id,
      attachment.id,
    );
  }
}
