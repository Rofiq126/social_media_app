import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field_ios.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/components/comment_tile.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/page/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final VoidCallback onPressed;
  const PostTile({super.key, required this.post, required this.onPressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //cubits
  late final postCubit = context.read<PostCubit>(); //post cubit
  late final profileCubit = context.read<ProfileCubit>(); //profile cubit

  //is current user post
  bool isCurrentUserPost = false;

  //current user
  AppUser? currentUser;

  //post user
  ProfileUser? postUser;

  @override
  void initState() {
    getCurrentUser();
    fetchPostUser();
    super.initState();
  }

  //get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isCurrentUserPost = (currentUser!.id == widget.post.uid);
  }

  //get all user post
  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.uid);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  //LIKES --------------

  //user tapped like button
  void toggleLikePost() async {
    //current like status
    final isLiked = widget.post.likes.contains(currentUser!.id);

    //optimiticlly like and update ui
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.id);
      } else {
        widget.post.likes.add(currentUser!.id);
      }
    });

    //update the like
    postCubit
        .toggeleLikePost(postId: widget.post.id, userId: currentUser!.id)
        .catchError((error) {
      //if there is an error, revert back to orginal values
      setState(() {
        if (isLiked) {
          widget.post.likes.remove(currentUser!.id); //revert unlike
        } else {
          widget.post.likes.add(currentUser!.id); //revert like
        }
      });
    });
  }

  //COMMENTS -------

  // comment controller
  final commentController = TextEditingController();

  //open comment box -> for user type
  void openNewCommentBox() {
    showAdaptiveDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Add a new comment'),
              ),
              content: MyTextFieldIos(
                  controller: commentController,
                  hintText: 'Type a comment',
                  obsecureText: false),
              actions: [
                //cancel button
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    commentController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                //save button
                CupertinoDialogAction(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    addComment();
                  },
                )
              ],
            ));
  }

  void addComment() async {
    //create a new comment
    final comment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.id,
        userName: currentUser!.name,
        text: commentController.text,
        timeStamp: DateTime.now());
    //add comment using cubit
    if (commentController.text.isNotEmpty) {
      postCubit.addComment(postId: widget.post.id, comment: comment);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please add comment before pressing save button')));
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  //show confirmation option for deletion
  void showOption(BuildContext context) {
    showAdaptiveDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('Delete Confirmation'),
              content: Text('Are you sure you want to delete this post?'),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onPressed();
                  },
                  isDestructiveAction: true,
                  child: Text('Delete'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    log('profile image url: ${postUser?.profileImageUrl}');
    return Container(
      color: color.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //top saction
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilePage(uid: widget.post.uid))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) => Container(
                              width: 40,
                              height: 40,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: color.primary),
                              child: Icon(
                                CupertinoIcons.person,
                                color: color.secondary,
                              )),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: color.primary),
                          child: Icon(CupertinoIcons.person),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                        color: color.inversePrimary,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  if (isCurrentUserPost) ...[
                    IconButton(
                        onPressed: () => showOption(context),
                        icon: Icon(
                          CupertinoIcons.delete_simple,
                          color: color.primary,
                        ))
                  ]
                ],
              ),
            ),
          ),
          //image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CupertinoActivityIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(
              CupertinoIcons.exclamationmark_bubble,
              color: color.primary,
            ),
          ),
          //button -> lik, comment, timestamp
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                //like
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: toggleLikePost,
                          child: widget.post.likes.contains(currentUser!.id)
                              ? Icon(
                                  CupertinoIcons.heart_solid,
                                  color: Colors.redAccent,
                                )
                              : Icon(CupertinoIcons.heart)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(color: color.primary),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                //comment
                GestureDetector(
                    onTap: openNewCommentBox,
                    child: Icon(
                      CupertinoIcons.chat_bubble_text,
                      color: color.primary,
                    )),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(color: color.primary),
                ),
                SizedBox(
                  width: 20,
                ),
                Spacer(),
                //timestamp
                Text(widget.post.timeStamp.toString())
              ],
            ),
          ),
          //caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.userName,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: Text(
                  widget.post.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
          ),
          //comment section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              //loading
              if (state is PostLoaded) {
                final post =
                    state.posts.firstWhere((post) => post.id == widget.post.id);
                if (post.comments.isNotEmpty) {
                  //how many comment that wanna show
                  int showCommentCount = post.comments.length;
                  //comment section
                  return ListView.builder(
                      itemCount: showCommentCount,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // get individual comment
                        final comment = post.comments[index];
                        //comment tile ui
                        return CommentTile(comment: comment);
                      });
                }
              } else if (state is PostLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is PostError) {
                return Center(
                    child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ));
              }
              return SizedBox();
            },
          )
        ],
      ),
    );
  }
}
