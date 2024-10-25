/*
Auth Repository -> Outline the possible with operation for this app
*/

import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  //Login
  Future<AppUser?> loginWithEmailAndPassword(
      {required String email, required String password});
  //Register
  Future<AppUser?> registerWithEmailAndPassword(
      {required String email, required String password, required String name});
  //Logout
  Future<void> logout();
  //Get current user data
  Future<AppUser?> getCurrentUser();
}
