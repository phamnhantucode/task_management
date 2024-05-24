import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/models/domain/project/project.dart';
import 'package:room_master_app/models/dtos/project/project.dart';

import '../../../main.dart';

part 'new_task_cubit.freezed.dart';
part 'new_task_state.dart';

class NewTaskCubit extends Cubit<NewTaskState> {
  NewTaskCubit() : super(const NewTaskState());

  late bool _isEdit;
  late Task _taskEdit;

  void taskNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void taskDescriptionChanged(String description) {
    emit(state.copyWith(description: description));
  }

  void taskOnChangeDateTime(
      {DateTime? startDate, DateTime? endDate, bool? isSingle = false}) {
    if (startDate != null) {
      if (isSingle == true) {
        emit(state.copyWith(startDate: startDate, endDate: endDate));
      } else {
        emit(state.copyWith(startDate: startDate));
      }
    }
    if (endDate != null) {
      emit(state.copyWith(endDate: endDate));
    }
  }

  void createTask(String projectId) {
    emit(state.copyWith(status: NewTaskSubmitStatus.submitting));
    try {
      var taskDto = TaskDto(
          id: uuid.v1(),
          name: state.name,
          description: state.description,
          status: TaskStatus.notStarted,
          projectId: projectId,
          authorId: FirebaseAuth.instance.currentUser!.uid,
          startDate: state.startDate ?? getCurrentTimestamp,
          endDate:
              state.endDate ?? getCurrentTimestamp.add(const Duration(days: 1)),
          createdAt: getCurrentTimestamp,
          updatedAt: getCurrentTimestamp,
          assigneeIds: []);
      if (_isEdit) {
        ProjectRepository.instance.updateTask(
            projectId,
            taskDto.copyWith(
              id: _taskEdit.id,
              updatedAt: getCurrentTimestamp,
              createdAt: _taskEdit.createdAt,
              assigneeIds: _taskEdit.assignees.map((e) => e.id).toList(),
              authorId: _taskEdit.author.id,
              status: _taskEdit.status,
            ));
      } else {
        ProjectRepository.instance.addTaskToProject(projectId, taskDto);
      }
      emit(state.copyWith(status: NewTaskSubmitStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NewTaskSubmitStatus.error, errorMessage: e.toString()));
      return;
    }
  }

  void init({required bool isEdit, Task? task}) {
    _isEdit = isEdit;
    _taskEdit = task!;
    if (isEdit) {
      emit(state.copyWith(
        name: task.name,
        description: task.description,
        startDate: task.startDate,
        endDate: task.endDate,
      ));
    }
  }
}
