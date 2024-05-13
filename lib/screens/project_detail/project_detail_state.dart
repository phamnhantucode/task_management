part of 'project_detail_cubit.dart';

@freezed
class ProjectDetailState with _$ProjectDetailState {
  const factory ProjectDetailState({
    Project? project,
    @Default([]) List<Task> tasks,
    @Default([]) List<Attachment> attachments,
    @Default(0.0) double progress,
}) = _ProjectDetailState;
}
