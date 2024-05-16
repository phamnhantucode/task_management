import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';

import '../../../domain/repositories/project/project_repository.dart';
import '../../../models/domain/project/project.dart';
import '../../../models/dtos/project/project.dart';

part 'upcoming_task_cubit.freezed.dart';
part 'upcoming_task_state.dart';

class UpcomingTaskCubit extends Cubit<UpcomingTaskState> {
  UpcomingTaskCubit() : super(const UpcomingTaskState());

  late StreamSubscription _tasksSubscription;
  late String userId;

  void init(String userId) {
    this.userId = userId;
    _tasksSubscription = ProjectRepository.instance
        .getTasksAssignedToUserStream(userId)
        .listen((tasks) {
      if (state.allTasks.isEmpty) {
        emit(state.copyWith(isLoadingList: true));
      }
      final selectedDateTasks =
          tasks.where((task) => isTimeSelectedTask(task)).toList();
      final selectedStatusTasks = selectedDateTasks
          .where((task) => state.selectedStatus == null
              ? true
              : task.status == state.selectedStatus)
          .toList();
      emit(state.copyWith(
          allTasks: tasks,
          selectedDateTasks: selectedDateTasks,
          selectedStatusTasks: selectedStatusTasks,
          isLoadingList: false));
    });
  }

  bool isTimeSelectedTask(Task task) {
    final selectedDate = state.selectedDate ?? getCurrentTimestamp;
    if (task.startDate == null && task.endDate == null) {
      return true;
    } else if (task.startDate != null) {
      if (task.endDate != null) {
        return task.startDate!.cleanHours <= selectedDate.cleanHours &&
            selectedDate.cleanHours <= task.endDate!.cleanHours;
      } else {
        return selectedDate.cleanHours >= task.startDate!.cleanHours;
      }
    } else {
      return selectedDate.cleanHours <= task.endDate!.cleanHours;
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription.cancel();
    return super.close();
  }

  void changeSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(
      isLoadingList: true,
      selectedDate: selectedDate,
    ));
    final selectedDateTasks =
        state.allTasks.where((task) => isTimeSelectedTask(task)).toList();
    final selectedStatusTasks = selectedDateTasks
        .where((task) => state.selectedStatus == null
            ? true
            : task.status == state.selectedStatus)
        .toList();
    log('selectedDateTasks: $selectedDateTasks');
    emit(state.copyWith(
        selectedDateTasks: selectedDateTasks,
        selectedStatusTasks: selectedStatusTasks,
        isLoadingList: false));
  }
}
