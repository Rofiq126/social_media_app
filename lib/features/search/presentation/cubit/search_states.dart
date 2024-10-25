import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class SearchStates {}

//initiate
class SearchInitial extends SearchStates {}

//loading
class SearchLoading extends SearchStates {}

//loadad
class SearchLoaded extends SearchStates {
  final List<ProfileUser?> user;
  SearchLoaded({required this.user});
}

//error
class SearchError extends SearchStates {
  final String message;
  SearchError({required this.message});
}
