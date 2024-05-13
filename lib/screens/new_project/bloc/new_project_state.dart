part of 'new_project_bloc.dart';

enum NewProjectStatus { initial, loading, success, error, edit }

@freezed
class NewProjectState with _$NewProjectState {
  const factory NewProjectState({
    @Default(NewProjectStatus.initial) NewProjectStatus status,
    @Default('') String name,
    @Default('') String description,
    required DateTime startDate,
    DateTime? endDate,
    String? avatarUrl,
    List<String>? membersId,
    CrudException? exception,
  }) = _NewProjectState;
}
