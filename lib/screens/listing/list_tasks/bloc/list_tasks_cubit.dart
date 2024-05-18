import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/dtos/project/project.dart';

import '../../../../domain/repositories/project/project_repository.dart';
import '../../../../models/domain/project/project.dart';

part 'list_tasks_cubit.freezed.dart';
part 'list_tasks_state.dart';

class ListTasksCubit extends Cubit<ListTasksState> {
  ListTasksCubit() : super(const ListTasksState());

  late StreamSubscription _tasksSubscription;
  late String _userId;

  void init(String userId) {
    _userId = userId;
    emit(state.copyWith(isLoading: true));
    _tasksSubscription = ProjectRepository.instance
        .getTasksAssignedToUserStream(userId)
        .listen((tasks) {
      emit(state.copyWith(task: tasks, isLoading: false));
      createCopyTasks();
    });
  }

  void createCopyTasks() {
    var tasksCopy = List<Task>.from(state.task);
    tasksCopy.sort((a, b) => switchTaskShortBy(a, b, state.shortBy));
    tasksCopy = tasksCopy
        .where((task) => switchTaskFilterBy(task, state.filterByStatuses))
        .toList();
    tasksCopy = tasksCopy
        .where((task) =>
            task.name.toLowerCase().contains(state.searchQuery.toLowerCase()))
        .toList();
    emit(state.copyWith(taskCopy: tasksCopy));
  }

  void searchTask(String searchQuery) {
    emit(state.copyWith(searchQuery: searchQuery));
    createCopyTasks();
  }

  void sortTask(TaskSortBy shortBy) {
    emit(state.copyWith(shortBy: shortBy));
    createCopyTasks();
  }

  void filterTask(List<TaskStatus> filterByStatuses) {
    emit(state.copyWith(filterByStatuses: filterByStatuses));
    createCopyTasks();
  }

  @override
  Future<void> close() {
    _tasksSubscription.cancel();
    return super.close();
  }

  int compareDates(DateTime? a, DateTime? b) {
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return 1;
    } else if (b == null) {
      return -1;
    } else {
      return a.compareTo(b);
    }
  }

  int switchTaskShortBy(Task a, Task b, TaskSortBy shortBy) {
    switch (shortBy) {
      case TaskSortBy.name:
        return a.name.compareTo(b.name);
      case TaskSortBy.startDate:
        return compareDates(a.startDate, b.startDate);
      case TaskSortBy.endDate:
        return compareDates(a.endDate, b.endDate);
    }
  }

  bool switchTaskFilterBy(Task task, List<TaskStatus> filterByStatuses) {
    if (filterByStatuses.contains(task.status)) {
      return true;
    } else {
      return false;
    }
  }
}
