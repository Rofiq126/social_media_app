import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile image pick
  PlatformFile? imagePickedFile;
  //web image pick
  Uint8List? webImage;
  //text controller
  final textController = TextEditingController();
  //current user
  AppUser? currentUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  //select image
  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //create and upload the post
  void uploadPost() {
    //check if both image and caption are provided
    if (imagePickedFile != null || textController.text.isNotEmpty) {
      //initiate post data
      final newPost = Post(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          uid: currentUser!.id,
          userName: currentUser!.name,
          text: textController.text,
          imageUrl: '',
          timeStamp: DateTime.now(),
          likes: [],
          comments: []);
      //post cubit
      final postCubit = context.read<PostCubit>();
      //web upload
      if (kIsWeb) {
        postCubit.createPost(post: newPost, imageBytes: imagePickedFile!.bytes);
      }
      //mobile upload
      else {
        postCubit.createPost(post: newPost, imagePath: imagePickedFile!.path);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image and caption is required')));
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        log('upload state: $state');
        //loading or uploading..
        if (state is PostLoading || state is PostUploading) {
          return ConstrainedScaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        } else {
          //build upload page
          return buildUploadPage();
        }

        //
      },
      listener: (context, state) {
        //go to previous page when upload is done and post are loaded
        if (state is PostLoaded) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildUploadPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload post
          IconButton(
              onPressed: () => uploadPost(),
              icon: Icon(CupertinoIcons.cloud_upload))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            //image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),
            //image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),
            const SizedBox(
              height: 10,
            ),
            //pick image buttons
            CupertinoButton(
                color: Colors.blue,
                child: Text('Select Image'),
                onPressed: () => pickImage()),
            const SizedBox(
              height: 10,
            ),
            //caption text box
            MyTextField(
                controller: textController,
                hintText: 'Caption',
                obsecureText: false)
          ],
        ),
      ),
    );
  }
}
