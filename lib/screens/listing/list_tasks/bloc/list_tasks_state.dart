part of 'list_tasks_cubit.dart';

@freezed
class ListTasksState with _$ListTasksState {
  const factory ListTasksState({
    @Default(false) bool isLoading,
    @Default([]) List<Task> task,
    @Default([]) List<Task> taskCopy,
    @Default('') String searchQuery,
    @Default(TaskSortBy.endDate) TaskSortBy shortBy,
    @Default(TaskStatus.values) List<TaskStatus> filterByStatuses,
  }) = _ListTasksState;
}

enum TaskSortBy {
  name,
  startDate,
  endDate;

  String getLocalizationText(BuildContext context) {
    switch (this) {
      case TaskSortBy.name:
        return context.l10n.text_name;
      case TaskSortBy.startDate:
        return context.l10n.text_start_date;
      case TaskSortBy.endDate:
        return context.l10n.text_end_date;
    }
  }
}

