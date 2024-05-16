part of 'home_screen_bloc.dart';

@freezed
class HomeScreenState with _$HomeScreenState {
  const factory HomeScreenState({
    @Default([]) List<Project> projects,
    @Default([]) List<Task> allTasks,
    @Default([]) List<Task> todayTasks,
    @Default([]) List<Task> nextTasks,
    @Default([]) List<Task> overdueTasks,
    @Default([]) List<TaskPieChartData> todayTasksPieChartData,
    @Default([]) List<TaskPieChartData> nextTasksPieChartData,
    @Default([]) List<TaskPieChartData> allTasksPieChartData,
}) = _HomeScreenState;
}
