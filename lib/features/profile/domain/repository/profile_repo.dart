import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  //fetch user
  Future<ProfileUser?> fetchUserProfile(String uid);
  //update user profile
  Future<void> updateProfile(ProfileUser updatedProfile);
  //toggle follow
  Future<void> toggleFollow(String currentUserId, String targetUserId);
}
