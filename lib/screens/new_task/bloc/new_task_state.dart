part of 'new_task_cubit.dart';

enum NewTaskSubmitStatus { initial, submitting, success, error }

@freezed
class NewTaskState with _$NewTaskState {
  const factory NewTaskState({
    @Default(NewTaskSubmitStatus.initial) NewTaskSubmitStatus status,
    @Default('') String name,
    @Default('') String description,
    DateTime? startDate,
    DateTime? endDate,
    String? assigneeId,
    String? projectId,
    String? errorMessage,
  }) = _NewTaskState;
}
