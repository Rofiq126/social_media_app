import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repository/post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostInitial());

  //create the post
  Future<void> createPost(
      {required Post post, String? imagePath, Uint8List? imageBytes}) async {
    try {
      //initiate variable for storing image url from bot platform
      String? imageUrl;

      //handle image upload for mobile platfom (using file path)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(
            path: imagePath, fileName: post.id);
        //handle image upload for web platform (using file bytes)
      } else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(
            fileBytes: imageBytes, fileName: post.id);
      }
      //give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      //create the post in the backend
      postRepo.createPost(newPost);

      //fetch all post
      await fetchAllPost();
    } catch (exception) {
      emit(PostError(message: 'failed to create post: $exception'));
    }
  }

  //fetch all post
  Future<void> fetchAllPost() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPost();
      emit(PostLoaded(posts: posts));
    } catch (exception) {
      emit(PostError(message: 'failed to fetch data: $exception'));
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (exception) {
      emit(PostError(message: 'failed to delete post: $exception'));
    }
  }

  //toggle like
  Future<void> toggeleLikePost(
      {required String postId, required String userId}) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (exception) {
      emit(PostError(message: 'failed to like post: $exception'));
    }
  }

  //add comment to post
  Future<void> addComment(
      {required String postId, required Comment comment}) async {
    try {
      //add comment
      await postRepo.addComment(postId: postId, comment: comment);

      //get all post
      await fetchAllPost();
    } catch (exception) {
      emit(PostError(message: 'Failed to add comment $exception'));
    }
  }

  //delete comment from the post
  Future<void> deleteComment(
      {required String postId, required String commentId}) async {
    try {
      //delete comment
      await postRepo.deleteComment(postId: postId, commentId: commentId);

      //get all post
      await fetchAllPost();
    } catch (exception) {
      emit(PostError(message: 'failed to delete post: $exception'));
    }
  }
}
