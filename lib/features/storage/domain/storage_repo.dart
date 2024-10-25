import 'dart:typed_data';

abstract class StorageRepo {
  //upload profile in mobile platform
  Future<String?> uploadProfileMobile(
      {required String path, required String fileName});
  //upload profile in web platform
  Future<String?> uploadProfileImageWeb(
      {required Uint8List fileBytes, required String fileName});
  //upload profile in mobile platform
  Future<String?> uploadPostImageMobile(
      {required String path, required String fileName});
  //upload profile in web platform
  Future<String?> uploadPostImageWeb(
      {required Uint8List fileBytes, required String fileName});
}
