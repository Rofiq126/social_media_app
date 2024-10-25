import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser(
      {required super.id,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl,
      required this.followers,
      required this.following});

  //method to update user profile
  ProfileUser copyWith(
      {String? newBio,
      String? newProfileImageUrl,
      List<String>? newFollowers,
      List<String>? newFollowing}) {
    return ProfileUser(
        bio: newBio ?? bio,
        profileImageUrl: newProfileImageUrl ?? '',
        id: id,
        email: email,
        followers: newFollowers ?? followers,
        following: newFollowing ?? following,
        name: name);
  }

  //convert profile user -> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following
    };
  }

  //convert json -> profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        id: json['uid'],
        email: json['email'],
        name: json['name'],
        bio: json['bio'] ?? '',
        profileImageUrl: json['profileImageUrl'] ?? '',
        followers: List<String>.from(json['followers'] ?? []),
        following: List<String>.from(json['following'] ?? []));
  }
}
