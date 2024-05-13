part of 'new_project_bloc.dart';

class NewProjectEvent extends Equatable {
  const NewProjectEvent();

  @override
  List<Object> get props => [];
}

class NewProjectNameChanged extends NewProjectEvent {
  final String name;

  const NewProjectNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class NewProjectDescriptionChanged extends NewProjectEvent {
  final String description;

  const NewProjectDescriptionChanged(this.description);

  @override
  List<Object> get props => [description];
}

class NewProjectConfirm extends NewProjectEvent {
  const NewProjectConfirm();
}

class CleanNewProject extends NewProjectEvent {
  const CleanNewProject();
}

class ClearNewProject extends NewProjectEvent {
  const ClearNewProject();
}