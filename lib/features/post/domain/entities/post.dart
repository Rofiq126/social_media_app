import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String uid;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;
  final List<String> likes; //store uuid
  final List<Comment> comments;

  Post(
      {required this.id,
      required this.uid,
      required this.likes,
      required this.userName,
      required this.text,
      required this.imageUrl,
      required this.timeStamp,
      required this.comments});

  Post copyWith({String? imageUrl}) {
    return Post(
        id: id,
        uid: uid,
        userName: userName,
        text: text,
        imageUrl: imageUrl ?? this.imageUrl,
        timeStamp: timeStamp,
        likes: likes,
        comments: comments);
  }

  //convert post -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson())
    };
  }

  //convert json -> post
  factory Post.fromJson(Map<String, dynamic> json) {
    //prepare the comment
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
        id: json['id'],
        uid: json['uid'],
        userName: json['userName'],
        text: json['text'],
        imageUrl: json['imageUrl'],
        timeStamp: (json['timeStamp'] as Timestamp).toDate(),
        likes: List<String>.from(json['likes'] ?? []),
        comments: comments);
  }
}
