import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/models/dtos/project/project.dart';

import '../../../main.dart';

part 'new_task_cubit.freezed.dart';
part 'new_task_state.dart';

class NewTaskCubit extends Cubit<NewTaskState> {
  NewTaskCubit() : super(const NewTaskState());

  void taskNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void taskDescriptionChanged(String description) {
    emit(state.copyWith(description: description));
  }

  void createTask(String projectId) {
    emit(state.copyWith(status: NewTaskSubmitStatus.submitting));
    try {
      ProjectRepository.instance.addTaskToProject(
          projectId,
          TaskDto(
              id: uuid.v1(),
              name: state.name,
              description: state.description,
              status: TaskStatus.notStarted,
              projectId: projectId,
              assigneeId: state.assigneeId,
              authorId: FirebaseAuth.instance.currentUser!.uid,
              createdAt: getCurrentTimestamp,
              updatedAt: getCurrentTimestamp));
      emit(state.copyWith(status: NewTaskSubmitStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NewTaskSubmitStatus.error, errorMessage: e.toString()));
      return;
    }
  }
}
