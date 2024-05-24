part of 'task_detail_cubit.dart';

@freezed
class TaskDetailInfoState with _$TaskDetailInfoState {
  const factory TaskDetailInfoState({
    List<UserDto>? assignees,
    TaskStatus? status,
    @Default('') String taskName,
    @Default('') String description,
    DateTime? startDate,
    DateTime? endDate,
    Project? project,
    @Default([]) List<Comment> comments,
    @Default('') String comment,
    @Default([]) List<String> attachmentPaths,
  }) = _TaskDetailInfoState;
}
