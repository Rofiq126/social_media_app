import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/presentation/component/my_drawer.dart';
import 'package:social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/post/presentation/page/upload_post_page.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();
  @override
  void initState() {
    //fetch all the post
    fetchAllPost();
    super.initState();
  }

  void fetchAllPost() async {
    await postCubit.fetchAllPost();
  }

  void deletePost(String postId) async {
    await postCubit.deletePost(postId).whenComplete(() => fetchAllPost());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          //upload new post button
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UploadPostPage())),
              icon: Icon(CupertinoIcons.add))
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          //loading
          if (state is PostLoading || state is PostUploading) {
            return Scaffold(
              body: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          //loaded
          else if (state is PostLoaded) {
            final allPost = state.posts;
            if (allPost.isEmpty) {
              return Center(
                child: Text('No post available'),
              );
            } else {
              return ListView.builder(
                  itemCount: allPost.length,
                  itemBuilder: (context, index) {
                    //get individual post
                    final post = allPost[index];
                    //list of post
                    return PostTile(
                        post: post, onPressed: () => deletePost(post.id));
                  });
            }
          }
          //error
          else if (state is PostError) {
            return Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            );
            //otherwise
          } else {
            return SizedBox();
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
