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
}) = _TaskDetailInfoState;}
