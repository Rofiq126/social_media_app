import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class SearchRepo {
  //searchUsers
  Future<List<ProfileUser?>> searchUsers(String query);
}
