import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_master_app/domain/repositories/test_repository.dart';
import 'package:room_master_app/models/dtos/test.dart';

class TestRepositoryImpl extends TestRepository {
  TestRepositoryImpl(FirebaseFirestore firebaseFirestore)
      : collectionReference =
            firebaseFirestore.collection('test').withConverter<Test>(
                  fromFirestore: (snapshot, options) =>
                      Test.fromJson(snapshot.data()!),
                  toFirestore: (value, options) => value.toJson(),
                );

  final CollectionReference<Test> collectionReference;

  @override
  Future<List<Test>> getTest() async {
    return collectionReference
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  @override
  Future<void> addTest(Test test) async {
    return collectionReference
        .doc(test.id)
        .set(test)
        .onError((error, stackTrace) {});
  }

  @override
  Future<void> removeTest(Test test) async {
    return collectionReference
        .doc(test.id)
        .delete()
        .onError((error, stackTrace) => null);
  }
}
