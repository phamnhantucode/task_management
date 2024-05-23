import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/notifications/notifications_repository.dart';
import 'package:room_master_app/domain/service/notification_service.dart';

import '../../domain/repositories/project/project_repository.dart';
import '../../main.dart';
import '../../models/domain/project/project.dart';
import '../../models/dtos/notification/action.dart';
import '../../models/dtos/notification/notification_dto.dart';
import '../../models/dtos/project/project.dart';
import '../../models/dtos/user/user_dto.dart';

part 'project_detail_cubit.freezed.dart';
part 'project_detail_state.dart';

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  ProjectDetailCubit() : super(const ProjectDetailState());

  late StreamSubscription<Project> projectSubscription;
  late StreamSubscription<List<Task>> tasksSubscription;
  late StreamSubscription<List<Attachment>> attachmentsSubscription;

  late StreamSubscription<List<Notes>> notesSubscription;
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
          endDate: project.endDate
      ));
    });
    notesSubscription = ProjectRepository.instance
        .getAllNotes(projectId)
        .listen((notes) {
      emit(state.copyWith(notes: notes));
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
    handleUpdateProjectNotification();
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
          ProjectRepository.instance.deleteTaskFromProject(task.id, state.project!.id);
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

  void updateMembers(List<UserDto> users, bool isAdd) {
    if (isAdd) {
      emit(state.copyWith(members: state.members + users));
      updateProject();
    } else {
      emit(state.copyWith(members: state.members.where((member) => !users.contains(member)).toList()));
      updateProject();
    }
  }

  void cancelUpdateProject() {
    if(state.project != null) {
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
    emit(state.copyWith(tasksCopy: state.tasksCopy.where((task) => task.id != taskId).toList()));
  }

  void addAttachment({required String fileName, required String downloadUrl}) {
    ProjectRepository.instance.addAttachmentToProject(state.project!.id, AttachmentDto(
        id: uuid.v1(),
        fileName: fileName,
        filePath: downloadUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ));
  }

  void removeAttachment(Attachment attachment) {
    ProjectRepository.instance.deleteAttachmentFromProject(
      state.project!.id,
      attachment.id,
    );
  }

  void handleUpdateProjectNotification() {
    if (state.projectName != state.project!.name) {
      final notify = NotifyChangeProjectNameDto(
          id: '',
          createdAt: getCurrentTimestamp,
          authorId: state.project!.owner.id,
          targetId: state.project!.id,
          userReceiveNotificationId: '',
          action: ActionNotification.changeProjectName,
          targetType: TargetType.project,
          title: state.project!.name,
          body: '',
          isRead: false,
          content: '',
          newProjectName: state.project!.name);
      Future.forEach(state.project!.members, (member) async {
        final notification = notify.copyWith(
          id: uuid.v1(),
          userReceiveNotificationId: member.id,
        );
        NotificationRepository.instance.addNotification(notification);
        NotificationService.instance.pushNotification(state.project!.owner.notificationToken ?? '', notification);
      });
    }
  }

  void updateProjectColor(Color color) {
    ProjectRepository.instance.updateProjectColor(state.project!.id, color);
  }

  void addProjectNote(String note) async {
    ProjectRepository.instance.addProjectNote(state.project!.id, NotesDto(
        id: uuid.v1(),
        content: note,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ));
  }

  void onChangeDueDate(DateTime e) {
    ProjectRepository.instance.updateProjectDueDate(state.project!.id, e);
  }

  void leaveProject(String? uid) {
    ProjectRepository.instance.leaveProject(state.project!.id, uid);
  }

  void deleteProject() {
      ProjectRepository.instance.deleteProject(state.project!.id);
  }
}
