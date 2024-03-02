part of 'test_bloc.dart';

@freezed
class TestState with _$TestState {
  const factory TestState({
    @Default('') String editableField,
    @Default([]) List<Test> test,
}) = _TestState;
}
