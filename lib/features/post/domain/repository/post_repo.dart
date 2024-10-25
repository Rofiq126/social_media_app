import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';

abstract class PostRepo {
  //fetch all post
  Future<List<Post>> fetchAllPost();
  //create post
  Future<void> createPost(Post post);
  //delete post
  Future<void> deletePost(String postId);
  //fetch post by user id
  Future<List<Post>> fetchPostByUserId(String userId);
  //toggle like post
  Future<void> toggleLikePost(String postId, String userId);
  //add comment
  Future<void> addComment({required String postId, required Comment comment});
  //delete comment
  Future<void> deleteComment(
      {required String postId, required String commentId});
}
