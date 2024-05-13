import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/repositories/project/project_repository.dart';
import '../../../models/domain/project/project.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';
part 'home_screen_bloc.freezed.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenState()) {
    on<InitBloc>(_handleInitBloc);
    on<FetchProjects>(_handleFetchProjects);
    on<DeleteProject>(_handleDeleteProject);
  }

  final userId = FirebaseAuth.instance.currentUser?.uid;


  FutureOr<void> _handleInitBloc(InitBloc event, Emitter<HomeScreenState> emit) async {
    await for (final projects in ProjectRepository.instance.getProjectsStream(userId ?? '')) {
      log('projects: $projects');
      if (!emit.isDone) {
        emit(state.copyWith(projects: projects));
      }
    }
  }


  FutureOr<void> _handleFetchProjects(FetchProjects event, Emitter<HomeScreenState> emit) {
  }

  FutureOr<void> _handleDeleteProject(DeleteProject event, Emitter<HomeScreenState> emit) async {
    await ProjectRepository.instance.deleteProject(event.projectId);
  }
}
