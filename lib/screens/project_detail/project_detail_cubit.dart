import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/repositories/project/project_repository.dart';
import '../../models/domain/project/project.dart';

part 'project_detail_state.dart';
part 'project_detail_cubit.freezed.dart';

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  ProjectDetailCubit() : super(const ProjectDetailState());

  late StreamSubscription<Project> projectSubscription;
  late StreamSubscription<List<Task>> tasksSubscription;
  late StreamSubscription<List<Attachment>> attachmentsSubscription;
  late StreamSubscription<double> progressSubscription;

  void init(String projectId) {
    projectSubscription = ProjectRepository.instance.getProjectStream(projectId).listen((project) {
      emit(state.copyWith(project: project));
    });
    tasksSubscription = ProjectRepository.instance.getTasksFromProjectStream(projectId).listen((tasks) {
      emit(state.copyWith(tasks: tasks));
    });
    attachmentsSubscription = ProjectRepository.instance.getAttachmentsFromProjectStream(projectId).listen((attachments) {
      emit(state.copyWith(attachments: attachments));
    });
    progressSubscription = ProjectRepository.instance.getProjectProgress(projectId).listen((progress) {
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
}
