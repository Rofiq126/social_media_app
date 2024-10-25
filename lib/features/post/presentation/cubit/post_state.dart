import 'package:social_media_app/features/post/domain/entities/post.dart';

abstract class PostState {}

//initial
class PostInitial extends PostState {}

//loading
class PostLoading extends PostState {}

//uploading
class PostUploading extends PostState {}

//error
class PostError extends PostState {
  final String message;
  PostError({required this.message});
}

//loaded
class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded({required this.posts});
}
