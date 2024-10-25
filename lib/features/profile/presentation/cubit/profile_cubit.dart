import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  //fetch user profile using repo -> useful for loading proifile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoadad(profileUser: user));
      } else {
        emit(ProfileError(message: 'User not found'));
      }
    } catch (exception) {
      emit(ProfileError(message: exception.toString()));
    }
  }

  //return user profile given id -> useful for loading many profile for post
  Future<ProfileUser?> getUserProfile(String uid) async {
    try {
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (exception) {
      throw Exception('Failed to fetch user data: $exception');
    }
  }

  //update both bio and profile
  Future<void> updateProfile(
      {required String uid,
      required String? bio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    try {
      emit(ProfileLoading());
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser != null) {
        //profile picture update
        String? imageDownloadUrl;

        //ensure there is image present
        if (imageWebBytes != null || imageMobilePath != null) {
          //is platform mobile
          if (imageMobilePath != null) {
            //upload file
            imageDownloadUrl = await storageRepo.uploadProfileMobile(
                path: imageMobilePath, fileName: uid);
            //is platform web
          } else if (imageWebBytes != null) {
            //upload file
            imageDownloadUrl = await storageRepo.uploadProfileImageWeb(
                fileBytes: imageWebBytes, fileName: uid);
          }
          if (imageDownloadUrl == null) {
            emit(ProfileError(message: 'Failed to upload an image'));
            return;
          }
        }

        //initiate update data
        final updatePofile = currentUser.copyWith(
            newBio: bio ?? currentUser.bio,
            newProfileImageUrl:
                imageDownloadUrl ?? currentUser.profileImageUrl);

        //update in repo
        await profileRepo.updateProfile(updatePofile);

        //refetch the updated profile
        await fetchUserProfile(uid);
      } else {
        emit(ProfileError(message: 'Failed to fetch user for profile update'));
      }
    } catch (exception) {
      emit(ProfileError(message: 'Update profile failed: $exception'));
    }
  }

  //toggle follow/unfollow
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      //toggle the follow
      await profileRepo.toggleFollow(currentUserId, targetUserId);
    } catch (exception) {
      emit(ProfileError(message: 'Failed to toggle follow: $exception'));
    }
  }
}
