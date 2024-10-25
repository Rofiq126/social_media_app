import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  //initiate firebase firestore
  final _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      //get user document from firestore
      final userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          //fetch followers and following
          // final followers = List<String>.from(userData['followers']);
          // final following = List<String>.from(userData['following']);
          return ProfileUser.fromJson(userData);
        }
      }
      return null;
    } catch (exception) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      //covert updated profile to json
      await _firebaseFirestore
          .collection('users')
          .doc(updatedProfile.id)
          .update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl
      });
    } catch (exception) {
      throw Exception('update user profile failed: $exception');
    }
  }

  @override
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      //fetch current user document from firestore
      final currentUserDocument =
          await _firebaseFirestore.collection('users').doc(currentUserId).get();
      //fetch target user doument from firestore
      final targetUserDocument =
          await _firebaseFirestore.collection('users').doc(targetUserId).get();

      //check if there is current user doc and target user doc
      if (currentUserDocument.exists && targetUserDocument.exists) {
        //fetch current user data
        final currentUserData = currentUserDocument.data();
        //fetch target user data
        final targetUserData = targetUserDocument.data();
        //check if there is data in current user data and target user data
        if (currentUserData != null && targetUserData != null) {
          //current following
          List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);
          //check if current user is already following target user
          if (currentFollowing.contains(targetUserId)) {
            //unfollow
            await _firebaseFirestore
                .collection('users')
                .doc(currentUserId)
                .update({
              'following': FieldValue.arrayRemove([targetUserId])
            });
            //remove current user from target user list of followers
            await _firebaseFirestore
                .collection('users')
                .doc(targetUserId)
                .update({
              'followers': FieldValue.arrayRemove([currentUserId])
            });
          } else {
            //follow
            await _firebaseFirestore
                .collection('users')
                .doc(currentUserId)
                .update({
              'following': FieldValue.arrayUnion([targetUserId])
            });
            //add user followers in
            await _firebaseFirestore
                .collection('users')
                .doc(targetUserId)
                .update({
              'followers': FieldValue.arrayUnion([currentUserId])
            });
          }
        }
      }
    } catch (exception) {
      throw Exception('Failed to toggle followers: $exception');
    }
  }
}
