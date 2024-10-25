import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repository/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      //get current user login
      final firebaseUser = _firebaseAuth.currentUser;

      //check user login
      if (firebaseUser == null) {
        return null;
      }
      //fetch user document from firestore
      DocumentSnapshot userDocument = await _firebaseFirestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      //check if user document is exist
      if (!userDocument.exists) {
        return null;
      }

      return AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          name: userDocument['name']);
    } catch (exception) {
      throw Exception('Get current user failed: $exception');
    }
  }

  @override
  Future<AppUser?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //fetch user document from firestore
      DocumentSnapshot userDocument = await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      //create user
      AppUser user = AppUser(
          id: userCredential.user!.uid,
          email: email,
          name: userDocument['name']);
      return user;
    } catch (exception) {
      //catch error
      throw Exception('Login failed: $exception');
    }
  }

  @override
  Future<void> logout() async {
    try {
      _firebaseAuth.signOut();
    } catch (exception) {
      throw Exception('Logout failed: $exception');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      //sign up
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //create user
      AppUser user =
          AppUser(id: userCredential.user!.uid, email: email, name: name);

      //save user data in firestore
      //it will be saved in firestore with id idetifier from data user
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toJson());

      return user;
    } catch (exception) {
      //catch error
      throw Exception('Login failed: $exception');
    }
  }
}
