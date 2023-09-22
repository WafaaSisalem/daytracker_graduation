import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class FirestorageHelper {
  FirestorageHelper._();
  static FirestorageHelper firestorageHelper = FirestorageHelper._();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<List<String>> uploadImage(List<File> files, String folderName) async {
    List<String> imagesUrls = [];
    for (File file in files) {
      String filePath = file.path;
      String fileName = filePath.split('/').last;
      String path = 'images/$folderName/$fileName';
      Reference reference = firebaseStorage.ref(path);
      await reference.putFile(file);
      String imageUrl = await reference.getDownloadURL();
      imagesUrls.add(imageUrl);
    }

    return imagesUrls;
  }
  // Future<String> uploadImage(File file, String folderName) async {
  //   String filePath = file.path;
  //   String fileName = filePath.split('/').last;
  //   String path = 'images/$folderName/$fileName';
  //   Reference reference = firebaseStorage.ref(path);
  //   await reference.putFile(file);
  //   String imageUrl = await reference.getDownloadURL();
  //   return imageUrl;
  // }

  Future<List<File>> selectFile() async {
    // File? file;
    // XFile? imageFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);

    // if (imageFile != null) {
    //   file = File(imageFile.path);
    // }
    // return file;
    final ImagePicker imagePicker = ImagePicker();
    List<XFile>? imageFileList = [];

    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 25);
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    List<File> files = imageFileList.map((file) => File(file.path)).toList();
    return files;
  }

  deleteImages(List imagesUrls) async {
    for (String url in imagesUrls) {
      await firebaseStorage.refFromURL(url).delete();
    }
  }
}
