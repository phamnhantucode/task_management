import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:room_master_app/models/enum/image_picker_type.dart';

class FileService {
  static final FileService instance =
      FileService._privateConstructor();

  FileService._privateConstructor();

  factory FileService() {
    return instance;
  }

  Future<String?> imageSelection(ImagePickerType pickerType) async {
    XFile? imageFile;
    final imagePicker = ImagePicker();
    switch (pickerType) {
      case ImagePickerType.gallery:
        imageFile = await imagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 90);
        break;
      case ImagePickerType.camera:
        imageFile = await imagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 90);
        break;
    }

    if (imageFile != null) {
      print("You selected  image : " + imageFile.path);
    } else {
      print("You have not taken image");
    }
    return imageFile?.path;
  }

  Future<String?> fileSelection(FileType pickerType) async {
    final result = await FilePicker.platform.pickFiles(
      type: pickerType,
    );
    if (result == null || result.files.single.path == null) {
      print('You have not taken file');
    } else {
      print("You selected file: ${result.files.single.path!}");
    }
    return result?.files.single.path;
  }
}
