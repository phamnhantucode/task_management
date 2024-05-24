import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' as collection;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/extensions/date_time.dart';

import '../../../common/utils/utils.dart';
import '../../../domain/repositories/project/project_repository.dart';
import '../../../models/domain/project/project.dart';
import '../../../models/dtos/project/project.dart';

part 'home_screen_bloc.freezed.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(const HomeScreenState());

  final userId = FirebaseAuth.instance.currentUser?.uid;

  late StreamSubscription _projectsSubscription;
  late StreamSubscription _tasksSubscription;

  void init() async {
    _projectsSubscription = ProjectRepository.instance
        .getProjectsStream(userId!)
        .listen((projects) {
      emit(state.copyWith(projects: projects));
    });
    _tasksSubscription = ProjectRepository.instance
        .getTasksAssignedToUserStream(userId!)
        .listen((tasks) {
          log('tasks: $tasks');
      final todayTask = tasks.where((task) => isTodayTask(task)).toList();
      final nextTask = tasks.where((task) => isNextTask(task)).toList();
      final taskTodayPieChartData = collection
          .groupBy<Task, TaskStatus>(todayTask, (task) => task.status)
          .map((key, value) => MapEntry(key, value.length))
          .entries
          .map((entry) =>
              TaskPieChartData(status: entry.key, taskCount: entry.value))
          .toList();
      final taskNextPieChartData = collection
          .groupBy<Task, TaskStatus>(nextTask, (task) => task.status)
          .map((key, value) => MapEntry(key, value.length))
          .entries
          .map((entry) =>
              TaskPieChartData(status: entry.key, taskCount: entry.value))
          .toList();
      final taskAllPieChartData = collection
          .groupBy<Task, TaskStatus>(tasks, (task) => task.status)
          .map((key, value) => MapEntry(key, value.length))
          .entries
          .map((entry) =>
              TaskPieChartData(status: entry.key, taskCount: entry.value))
          .toList();
      emit(state.copyWith(
          allTasks: tasks,
          todayTasks: todayTask,
          nextTasks: nextTask,
          todayTasksPieChartData: taskTodayPieChartData,
          nextTasksPieChartData: taskNextPieChartData,
          allTasksPieChartData: taskAllPieChartData));
    });
  }

  void deleteProject(String projectId) async {
    try {
      await ProjectRepository.instance.deleteProject(projectId);
    } catch (e) {
      log(e.toString());
    }
  }

  bool isTodayTask(Task task) {
    if (task.startDate == null && task.endDate == null) {
      return true;
    } else if (task.startDate != null) {
      if (task.endDate != null) {
        return isTodayBetween(task.startDate!, task.endDate!);
      } else {
        return getCurrentTimestamp.cleanHours >= task.startDate!.cleanHours;
      }
    } else {
      return getCurrentTimestamp.cleanHours <= task.endDate!.cleanHours;
    }
  }

  @override
  Future<void> close() {
    _projectsSubscription.cancel();
    _tasksSubscription.cancel();
    return super.close();
  }

  bool isNextTask(Task task) {
    if (task.startDate == null && task.endDate == null) {
      return true;
    } else if (task.startDate != null) {
      return getCurrentTimestamp.cleanHours < task.startDate!.cleanHours;
    } else {
      return getCurrentTimestamp < task.endDate!.cleanHours;
    }
  }
}

class TaskPieChartData {
  final TaskStatus status;
  final int taskCount;

  TaskPieChartData({required this.status, required this.taskCount});
}
