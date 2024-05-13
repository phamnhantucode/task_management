part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  const factory HomeScreenEvent.fetchProjects() = FetchProjects;

  const factory HomeScreenEvent.deleteProject(String projectId) = DeleteProject;

  const factory HomeScreenEvent.initBloc() = InitBloc;
}

class InitBloc extends HomeScreenEvent {
  const InitBloc() : super();

  @override
  List<Object> get props => [];
}

class FetchProjects extends HomeScreenEvent {
  const FetchProjects() : super();

  @override
  List<Object> get props => [];
}

class DeleteProject extends HomeScreenEvent {
  final String projectId;

  const DeleteProject(this.projectId) : super();

  @override
  List<Object> get props => [projectId];
}
