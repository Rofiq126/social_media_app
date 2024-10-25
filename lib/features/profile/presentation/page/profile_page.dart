import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/profile/presentation/component/bio_box.dart';
import 'package:social_media_app/features/profile/presentation/component/follow_button.dart';
import 'package:social_media_app/features/profile/presentation/component/profile_stats.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:social_media_app/features/profile/presentation/page/edit_profile_page.dart';
import 'package:social_media_app/features/profile/presentation/page/follower_page.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubit
  late final _profileCubit = context.read<ProfileCubit>();
  late final authCubit = context.read<AuthCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;

  //posts
  int postCount = 0;

  //follow method
  void followButtonMethod() {
    final profileState = _profileCubit.state;
    if (profileState is! ProfileLoadad) {
      return; //return is profile is not loaded
    } else {
      final profileUser = profileState.profileUser;
      final isFollowing = profileUser.followers.contains(currentUser!.id);

      //optimitiscally update UI
      setState(() {
        if (isFollowing) {
          //unfollow
          profileUser.followers.remove(currentUser!.id);
        } else {
          //follow
          profileUser.followers.add(currentUser!.id);
        }
        //perform actual toggle cubit
        _profileCubit
            .toggleFollow(currentUser!.id, widget.uid)
            .catchError((error) {
          //revert the update if there is an error
          if (isFollowing) {
            //unfollow
            profileUser.followers.add(currentUser!.id);
          } else {
            //follow
            profileUser.followers.remove(currentUser!.id);
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //load user profile data
    _profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    //is current user post
    bool isCurrentUserPost = widget.uid == currentUser!.id;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoadad) {
          //get loadad user
          final user = profileState.profileUser;

          return ConstrainedScaffold(
            appBar: AppBar(
              foregroundColor: color.primary,
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(CupertinoIcons.back)),
              title: Text(user.name),
              actions: [
                //edit profile
                if (isCurrentUserPost)
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProfilePage(
                                    user: user,
                                  ))),
                      icon: Icon(CupertinoIcons.settings))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    user.email,
                    style: TextStyle(color: color.primary),
                  ),
                  const SizedBox(height: 25),

                  CachedNetworkImage(
                      imageUrl: user.profileImageUrl,
                      //loading
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                      //error
                      errorWidget: (context, url, error) => Icon(
                            CupertinoIcons.person,
                            size: 72,
                            color: color.primary,
                          ),
                      //loaded
                      imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            width: 100,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          )),
                  const SizedBox(
                    height: 25,
                  ),
                  //profile stats
                  ProfileStats(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FollowerPage(
                                  follower: user.followers,
                                  following: user.following))),
                      postCount: postCount,
                      followerCount: user.followers.length,
                      followCount: user.following.length),
                  const SizedBox(
                    height: 25,
                  ),
                  //follow button
                  if (!isCurrentUserPost)
                    FollowButton(
                        onPressed: followButtonMethod,
                        isFollowing: user.followers.contains(currentUser!.id)),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        Text(
                          'Bio',
                          style: TextStyle(color: color.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  BioBox(
                    text: user.bio,
                  ),
                  //post
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 25),
                    child: Row(
                      children: [
                        Text(
                          'Post',
                          style: TextStyle(color: color.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //list of post from this user
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
                      //loaded
                      if (state is PostLoaded) {
                        //filter the post
                        final userPost = state.posts
                            .where((post) => post.uid == widget.uid)
                            .toList();
                        postCount = userPost.length;

                        return ListView.builder(
                            itemCount: postCount,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              //get individual post
                              final post = userPost[index];
                              return PostTile(
                                  post: post,
                                  onPressed: () => context
                                      .read<PostCubit>()
                                      .deletePost(post.id));
                            });
                      } else if (state is PostLoading) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      } else {
                        return Center(
                          child: Text('No posts..'),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        } else if (profileState is ProfileLoading) {
          return ConstrainedScaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        } else {
          return ConstrainedScaffold(
            body: Center(
              child: Text('No profile found..'),
            ),
          );
        }
      },
    );
  }
}
