import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../../../domain/repositories/project/project_repository.dart';
import '../../../../models/domain/project/project.dart';

part 'list_projects_cubit.freezed.dart';
part 'list_projects_state.dart';

class ListProjectsCubit extends Cubit<ListProjectsState> {
  ListProjectsCubit() : super(const ListProjectsState());

  late StreamSubscription _projectsSubscription;
  late String userId;

  void init(String userId) {
    emit(state.copyWith(isLoading: true));
    this.userId = userId;
    _projectsSubscription =
        ProjectRepository.instance.getProjectsStream(userId).listen((projects) {
      emit(state.copyWith(projects: projects, isLoading: false));
      createCopyProjects();
    });
  }

  void createCopyProjects() {
    var projectsCopy = List<Project>.from(state.projects);
    projectsCopy.sort((a, b) => switchProjectShortBy(a, b, state.shortBy));
    projectsCopy = projectsCopy
        .where((project) => switchProjectFilterBy(project, state.filterBy))
        .toList();
    projectsCopy = projectsCopy
        .where((project) => project.name
            .toLowerCase()
            .contains(state.searchQuery.toLowerCase()))
        .toList();
    emit(state.copyWith(projectsCopy: projectsCopy));
  }

  void searchProject(String searchQuery) {
    emit(state.copyWith(searchQuery: searchQuery));
    createCopyProjects();
  }

  void sortProject(ProjectSortBy shortBy) {
    emit(state.copyWith(shortBy: shortBy));
    createCopyProjects();
  }

  void filterProject(ProjectFilterBy filterBy) {
    emit(state.copyWith(filterBy: filterBy));
    createCopyProjects();
  }

  @override
  Future<void> close() {
    _projectsSubscription.cancel();
    return super.close();
  }

  int switchProjectShortBy(Project a, Project b, ProjectSortBy shortBy) {
    switch (shortBy) {
      case ProjectSortBy.name:
        return a.name.compareTo(b.name);
      case ProjectSortBy.startDate:
        return a.startDate.compareTo(b.startDate);
      case ProjectSortBy.endDate:
        if (a.endDate == null && b.endDate == null) {
          return 0;
        } else if (a.endDate == null) {
          return 1;
        } else if (b.endDate == null) {
          return -1;
        } else {
          return a.endDate!.compareTo(b.endDate!);
        }
    }
  }

  bool switchProjectFilterBy(Project project, ProjectFilterBy filterBy) {
    switch (filterBy) {
      case ProjectFilterBy.all:
        return true;
      case ProjectFilterBy.owner:
        return project.owner.id == userId;
      case ProjectFilterBy.member:
        return project.members
            .map((e) => e.id)
            .where((element) => element != project.owner.id)
            .contains(userId);
    }
  }
}
