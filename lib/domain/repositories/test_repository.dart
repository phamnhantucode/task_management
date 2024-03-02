import '../../models/dtos/test.dart';

abstract class TestRepository {
  Future<List<Test>> getTest();
  Future<void> addTest(Test test);
  Future<void> removeTest(Test test);
}