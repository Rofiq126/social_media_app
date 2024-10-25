import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //mobile image picker
  PlatformFile? imagePickedFile;

  //web image picker
  Uint8List? webImage;

  //bio text editing controller
  final bioController = TextEditingController();

  //pick image method
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

  //update profile button pressed
  Future<void> updateProfile() async {
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepare data
    final String uid = widget.user.id;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final bio = bioController.text;

    //ensure there is data for update
    if (bio.isNotEmpty || imagePickedFile != null) {
      //updating data
      profileCubit.updateProfile(
          uid: uid,
          bio: bio,
          imageMobilePath: imageMobilePath,
          imageWebBytes: imageWebBytes);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please change the data before pressing update button')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //profile loading
        if (state is ProfileLoading) {
          return ConstrainedScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Uploading....')
                ],
              ),
            ),
          );
          //profile error
        } else if (state is ProfileError) {
          return ConstrainedScaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
          //edit form
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoadad) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    final color = Theme.of(context).colorScheme;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        foregroundColor: color.primary,
        actions: [
          //save button
          IconButton(
              onPressed: () => updateProfile(),
              icon: Icon(CupertinoIcons.cloud_upload))
        ],
      ),
      body: Column(
        children: [
          //profile picture
          Center(
              child: Container(
            height: 200,
            width: 200,
            decoration:
                BoxDecoration(color: color.secondary, shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child:
                //display selected for mobile
                (!kIsWeb && imagePickedFile != null)
                    ? Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.cover,
                      )
                    :
                    //display selected for web
                    (kIsWeb && webImage != null)
                        ? Image.memory(
                            webImage!,
                            fit: BoxFit.cover,
                          )
                        :
                        //no image selected -> display existing profile picture
                        CachedNetworkImage(
                            imageUrl: widget.user.profileImageUrl,
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
                            imageBuilder: (context, imageProvider) => Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
          )),
          const SizedBox(
            height: 25,
          ),
          //pick image button
          CupertinoButton(
            color: Colors.blue,
            onPressed: () => pickImage(),
            child: Text('Pick Image'),
          ),
          const SizedBox(
            height: 25,
          ),
          //bio
          const Text('Bio'),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: MyTextField(
                controller: bioController,
                hintText: widget.user.bio,
                obsecureText: false),
          )
        ],
      ),
    );
  }
}
