import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/exception/crud_exception.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/main.dart';

import '../../../models/dtos/project/project.dart';

part 'new_project_event.dart';
part 'new_project_state.dart';
part 'new_project_bloc.freezed.dart';

class NewProjectBloc extends Bloc<NewProjectEvent, NewProjectState> {
  NewProjectBloc() : super(NewProjectState(startDate: getCurrentTimestamp)) {
    on<NewProjectNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<NewProjectDescriptionChanged>((event, emit) {
      emit(state.copyWith(description: event.description));
    });
    on<NewProjectConfirm>((event, emit) {
      emit(state.copyWith(status: NewProjectStatus.loading));
      try {
        ProjectRepository.instance.addProject(ProjectDto(
          id: uuid.v1(),
          name: state.name,
          ownerId: FirebaseAuth.instance.currentUser!.uid,
          description: state.description,
          startDate: state.startDate,
          endDate: state.endDate,
          membersId: [FirebaseAuth.instance.currentUser!.uid],
          status: ProjectStatus.notStarted,
          createdAt: getCurrentTimestamp,
          updatedAt: getCurrentTimestamp,
        ));
        emit(state.copyWith(status: NewProjectStatus.success));
      } catch (e) {
        if (e is Exception) {
          emit(state.copyWith(
            status: NewProjectStatus.error,
            exception: CrudException.fromException(e),
          ));
        } else {
          emit(state.copyWith(
            status: NewProjectStatus.error,
            exception: GenericException('An unknown error occurred'),
          ));
        }
      }
    });

    on<CleanNewProject>((event, emit) {
      emit(state.copyWith(status: NewProjectStatus.initial,exception: null));
    });

    on<ClearNewProject>((event, emit) {
      emit(NewProjectState(startDate: getCurrentTimestamp));
    });

    on<DueDateChange>((event, emit) {
      emit(state.copyWith(endDate: state.endDate?.copyWith(year: event.endDate.year, month: event.endDate.month, day: event.endDate.day) ?? event.endDate));
    },);


    on<DueTimeChange>((event, emit) {
      emit(state.copyWith(endDate: state.endDate?.copyWith(hour: event.endTime.hour, minute: event.endTime.minute)));
    },);
  }
}
