part of 'test_bloc.dart';

sealed class TestEvent extends Equatable {}

class OnEditableFieldChange extends TestEvent {
  OnEditableFieldChange({required this.newString});

  final String newString;

  @override
  List<Object?> get props => [newString];
}

class OnSubmit extends TestEvent {
  @override
  List<Object?> get props => [];
}

class OnRemoveTest extends TestEvent {
  OnRemoveTest({required this.test});

  final Test test;

  @override
  List<Object?> get props => [test];
}

class OnInitial extends TestEvent {
  @override
  List<Object?> get props => [];
}
