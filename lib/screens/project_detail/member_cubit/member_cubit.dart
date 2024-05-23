import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/repositories/project/project_repository.dart';
import '../../../models/dtos/user/user_dto.dart';

part 'member_state.dart';

part 'member_cubit.freezed.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit() : super(const MemberState());

  late StreamSubscription projectSubscription;
  late String projectId;

  void init(String projectId, List<UserDto>? selectedUsers) {
    this.projectId = projectId;
    projectSubscription = ProjectRepository.instance
        .getProjectStream(projectId)
        .listen((project) {
      emit(state.copyWith(
        members: project.members.toList().where((element) => element.id != project.owner.id).toList(),
        memberSelected: selectedUsers ?? [],
        memberFiltered: project.members,
      ));
      updateMemberFiltered();
    });
  }

  void changeSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    updateMemberFiltered();
  }

  void updateMemberFiltered() {
    emit(state.copyWith(
        memberFiltered: state.members
            .where((element) =>
        state.searchQuery.isNotEmpty
            ? element.firstName!.toLowerCase().contains(state.searchQuery)
            : true)
            .toList()));
  }

  void removeMember(String userId) {
    ProjectRepository.instance.removeMember(projectId, userId);
  }

  void assignTaskFor(UserDto user) {
    if (state.memberSelected.contains(user)) {
      emit(state.copyWith(
          memberSelected: state.memberSelected.toList()..remove(user)));
    } else {
      emit(state.copyWith(
          memberSelected: state.memberSelected.toList()..add(user)));
    }
  }
}
