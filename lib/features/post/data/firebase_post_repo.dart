import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repository/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  //store the post in collection called 'post'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (exception) {
      throw Exception('failed to create post: $exception');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (exception) {
      throw Exception('failed to delete data: $exception');
    }
  }

  @override
  Future<List<Post>> fetchAllPost() async {
    try {
      //get all most recent data at the top
      final postSnapshot =
          await postsCollection.orderBy('timeStamp', descending: true).get();

      //convert each firestore document to list of post
      final List<Post> allPost = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPost;
    } catch (exception) {
      throw Exception('Error fetching data: $exception');
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      //fetch post snapshot with current uid
      final postSnapshot =
          await postsCollection.where('uid', isEqualTo: userId).get();
      //convert user fromJson
      final userPost = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPost;
    } catch (exception) {
      throw Exception('Failed to fetch post by user id: $exception');
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //get post document from firestore
      final postDocument = await postsCollection.doc(postId).get();
      if (postDocument.exists) {
        final post = Post.fromJson(postDocument.data() as Map<String, dynamic>);
        //check if user is already like this post
        final hasLike = post.likes.contains(userId);

        //update the likes list
        //if user already like the post it will remove user from the list
        //when user is not like the post it will add user to the list
        if (hasLike) {
          post.likes.remove(userId); //unlike
        } else {
          post.likes.add(userId); // like
        }
        //update the post document with new like list
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception('Post not found');
      }
    } catch (exception) {
      throw Exception('Error toggling like: $exception');
    }
  }

  @override
  Future<void> addComment(
      {required String postId, required Comment comment}) async {
    try {
      //get post document
      final postDocument = await postsCollection.doc(postId).get();

      //check is there post exist
      if (postDocument.exists) {
        //prepare the post
        final post = Post.fromJson(postDocument.data() as Map<String, dynamic>);

        //add new comment
        post.comments.add(comment);

        //update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments':
              post.comments.map((commment) => commment.toJson()).toList()
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (exception) {
      throw Exception('Failed to adding comment: $exception');
    }
  }

  @override
  Future<void> deleteComment(
      {required String postId, required String commentId}) async {
    try {
      //get post document
      final postDocument = await postsCollection.doc(postId).get();

      //check is there post exist
      if (postDocument.exists) {
        //prepare the post
        final post = Post.fromJson(postDocument.data() as Map<String, dynamic>);

        //add new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments':
              post.comments.map((commment) => commment.toJson()).toList()
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (exception) {
      throw Exception('Failed to adding comment: $exception');
    }
  }
}
