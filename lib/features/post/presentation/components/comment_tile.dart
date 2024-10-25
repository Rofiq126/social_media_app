import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  //current user
  AppUser? currentUser;
  bool isCurrentUserPost = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //get current user data
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isCurrentUserPost = (widget.comment.userId == currentUser!.id);
  }

  void deleteComment() {
    showAdaptiveDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('Delete Confirmation'),
              content: Text('Are you sure you want to delete this comment?'),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Delete'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final postCubit = context.read<PostCubit>();
                    await postCubit.deleteComment(
                        postId: widget.comment.postId,
                        commentId: widget.comment.id);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  //show confirmation option for deletion
  void showOption(BuildContext context) {
    showAdaptiveDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('Delete Confirmation'),
              content: Text('Are you sure you want to delete this comment?'),
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
                    deleteComment();
                  },
                  isDestructiveAction: true,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          //user name
          Text(
            widget.comment.userName,
            style: TextStyle(fontWeight: FontWeight.w600, color: color.primary),
          ),
          const SizedBox(
            width: 5,
          ),
          //comment
          Flexible(
              child: Text(
            widget.comment.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color.primary),
          )),
          const Spacer(),
          if (isCurrentUserPost)
            GestureDetector(
              onTap: deleteComment,
              child: Icon(
                CupertinoIcons.ellipsis,
                color: color.primary,
              ),
            )
        ],
      ),
    );
  }
}
