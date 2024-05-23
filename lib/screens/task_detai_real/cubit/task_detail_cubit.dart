import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/models/domain/project/project.dart';
import 'package:room_master_app/models/dtos/project/project.dart';

import '../../../models/dtos/user/user_dto.dart';

part 'task_detail_cubit.freezed.dart';
part 'task_detail_state.dart';
class TaskDetailCubit extends Cubit<TaskDetailInfoState> {
  TaskDetailCubit() : super(const TaskDetailInfoState());

  void init(String projectId, String taskId) async {
    Task? task = await ProjectRepository.instance
        .getTaskDetail(projectId, taskId);

    if (task != null) {
      emit(state.copyWith(
        taskName: task.name,
        description: task.description,
        status: task.status,
        assignees: task.assignees,
        startDate: task.startDate,
        endDate: task.endDate,
      ));
    }
}
  void assignTaskFor(UserDto user, bool isCurrentAdded) {
    // if (isCurrentAdded) {
    //   emit(state.copyWith(assignee: null));
    // } else {
    //   emit(state.copyWith(assignee: user));
    // }
  }
}