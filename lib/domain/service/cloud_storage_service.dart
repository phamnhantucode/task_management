import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:room_master_app/common/constant.dart';
import 'package:room_master_app/main.dart';

class CloudStorageService {
  static final CloudStorageService instance = CloudStorageService._privateConstructor();
  CloudStorageService._privateConstructor();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _upload(String path, String fileName, Uint8List fileData) async {
    final Reference reference = _storage.ref().child(path).child(fileName);
    await reference.putData(fileData);
    return await reference.getDownloadURL();
  }

  Future<String?> uploadImage(String localPath) async {
    return _upload(AppConstants.imageCloudStoragePath, '${uuid.v1()}${extension(localPath)}', File(localPath).readAsBytesSync());
  }

  Future<String?> uploadFile(String localPath) async {
    return _upload(AppConstants.fileCloudStoragePath, '${uuid.v1()}${extension(localPath)}', File(localPath).readAsBytesSync());
  }

  Future<bool> deleteFile(String path, String fileName) async {
    try {
      final Reference reference = _storage.ref().child(path).child(fileName);
      await reference.delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}