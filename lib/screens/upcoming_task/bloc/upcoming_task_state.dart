part of 'upcoming_task_cubit.dart';

@freezed
class UpcomingTaskState with _$UpcomingTaskState {
  const factory UpcomingTaskState({
    @Default([]) List<Task> allTasks,
    DateTime? selectedDate,
    @Default([]) List<Task> selectedDateTasks,
    TaskStatus? selectedStatus,
    @Default([]) List<Task> selectedStatusTasks,
    @Default(false) bool isLoadingList,
  }) = _UpcomingTaskState;
}