import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(String path, String fileName, Uint8List fileData,
      [void Function(double progress)? uploading]) async {
    final Reference reference = _storage.ref().child(path).child(fileName);
    // final UploadTask uploadTask = reference.putData(fileData);
    await reference.putData(fileData);
    // uploadTask.snapshotEvents.listen((event) async {
    //   switch (event.state) {
    //     case TaskState.paused:
    //       break;
    //     case TaskState.running:
    //       final progress = 100.0 * (event.bytesTransferred / event.totalBytes);
    //       if (uploading != null) uploading(progress);
    //       break;
    //     case TaskState.success:
    //       break;
    //     case TaskState.canceled:
    //       break;
    //     case TaskState.error:
    //       break;
    //   }
    // });
    return await reference.getDownloadURL();
  }

  Future<bool> deleteFile(String path, String fileName) async {
    try {
      final Reference reference = _storage.ref().child(path).child(fileName);
      await reference.delete();

      return true;
    } catch (e) {
      log('Error deleting file: $e');
      return false;
    }
  }
}
