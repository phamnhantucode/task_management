part of 'project_detail_cubit.dart';

@freezed
class ProjectDetailState with _$ProjectDetailState {
  const factory ProjectDetailState({
    Project? project,
    @Default([]) List<Task> tasks,
    @Default([]) List<Task> tasksCopy,
    @Default([]) List<Attachment> attachments,
    @Default([]) List<User> members,
    @Default(0.0) double progress,
    @Default('') String projectName,
    @Default('') String projectDescription,
    DateTime? startDate,
    DateTime? endDate,
}) = _ProjectDetailState;
}
