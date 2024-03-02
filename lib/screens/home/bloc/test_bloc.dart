import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/test_repository.dart';
import 'package:room_master_app/main.dart';

import '../../../models/dtos/test.dart';

part 'test_bloc.freezed.dart';

part 'test_event.dart';

part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc(this.testRepository) : super(const TestState()) {
    on<OnEditableFieldChange>(_handleOnEditableFieldChange);
    on<OnSubmit>(_handleOnSubmit);
    on<OnRemoveTest>(_handleOnRemoveTest);
    on<OnInitial>((event, emit) => _refreshListTest(emit),);
  }

  final TestRepository testRepository;

  Future<void> _handleOnEditableFieldChange(
    OnEditableFieldChange event,
    Emitter<TestState> emit,
  ) async {
    emit(state.copyWith(editableField: event.newString));
  }

  Future<void> _handleOnSubmit(
    OnSubmit event,
    Emitter<TestState> emit,
  ) async {
    final test = Test(
        id: uuid.v1(),
        createdAt: getCurrentTimestamp,
        editableField: state.editableField,
        updatedAt: getCurrentTimestamp);
    await testRepository.addTest(test);
    emit(state.copyWith(test: await testRepository.getTest()));
  }

  Future<void> _handleOnRemoveTest(
    OnRemoveTest event,
    Emitter<TestState> emit,
  ) async {
    await testRepository.removeTest(event.test);
    emit(state.copyWith(test: await testRepository.getTest()));
  }

  Future<void> _refreshListTest(
    Emitter<TestState> emit,
  ) async {
    emit(state.copyWith(
        test: (await testRepository.getTest()).sortedBy(
      (element) => element.updatedAt,
    )));
  }
}
