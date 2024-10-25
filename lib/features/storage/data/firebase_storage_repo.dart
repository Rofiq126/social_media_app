import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final _firebaseStorage = FirebaseStorage.instance;

  /*

  PROFILE PICTURES - upload image to storage
  
  */

  //mobile platform
  @override
  Future<String?> uploadProfileImageWeb(
          {required Uint8List fileBytes, required String fileName}) async =>
      await _uploadFileBytes(
          fileBytes: fileBytes, fileName: fileName, folder: 'profile_images');

  //web platform
  @override
  Future<String?> uploadProfileMobile(
          {required String path, required String fileName}) async =>
      await _uploadFile(
          path: path, fileName: fileName, folder: 'profile_images');

  /*

  POST IMAGES - upload image to storage
  
  */

  //mobile platform
  @override
  Future<String?> uploadPostImageMobile(
          {required String path, required String fileName}) async =>
      await _uploadFile(path: path, fileName: fileName, folder: 'post_mages');

  //web platform
  @override
  Future<String?> uploadPostImageWeb(
          {required Uint8List fileBytes, required String fileName}) async =>
      await _uploadFileBytes(
          fileBytes: fileBytes, fileName: fileName, folder: 'post_images');

  //HELPER METHODS - to upload files to storage

  //mobile platform (file)
  Future<String?> _uploadFile(
      {required String path,
      required String fileName,
      required String folder}) async {
    try {
      //get file
      final file = File(path);

      //find place to store
      final storageRef = _firebaseStorage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await storageRef.putFile(file);

      //get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (exception) {
      throw Exception('failed to upload image: $exception');
    }
  }

  //web platform (web)
  Future<String?> _uploadFileBytes(
      {required Uint8List fileBytes,
      required String fileName,
      required String folder}) async {
    try {
      //find place to store
      final storageRef = _firebaseStorage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await storageRef.putData(fileBytes);

      //get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (exception) {
      throw Exception('failed to upload image: $exception');
    }
  }
}
