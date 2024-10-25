import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

//initial
class ProfileInitial extends ProfileState {}

//loading
class ProfileLoading extends ProfileState {}

//loadad
class ProfileLoadad extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoadad({required this.profileUser});
}

//error
class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
