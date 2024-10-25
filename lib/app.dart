import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/page/auth_page.dart';
import 'package:social_media_app/features/home/presentation/page/home_page.dart';
import 'package:social_media_app/features/post/data/firebase_post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/profile/data/firebase_profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/search/data/firebase_search_repo.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:social_media_app/features/storage/data/firebase_storage_repo.dart';
import 'package:social_media_app/themes/theme_cubit.dart';

class MyApp extends StatelessWidget {
  //auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();
  //profile repo
  final firebasepProfileRepo = FirebaseProfileRepo();
  //storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();
  //post repo
  final firebasePostRepo = FirebasePostRepo();
  //search repo
  final searchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provider cubit to app
    return MultiBlocProvider(
      providers: [
        //auth cubit
        BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepo: firebaseAuthRepo)..checkAuth()),
        //profile cubit
        BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
                profileRepo: firebasepProfileRepo,
                storageRepo: firebaseStorageRepo)),
        //post cubit
        BlocProvider<PostCubit>(
            create: (context) => PostCubit(
                postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo)),
        //search cubit
        BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(searchRepo: searchRepo)),
        //theme cubit
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              log('State Now: $authState');
              //Unauthenticated
              if (authState is Unauthenticated) {
                return AuthPage();
                //Authenticated
              } else if (authState is Authenticated) {
                return const HomePage();
                //Loading
              } else {
                return Scaffold(
                  body: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
            },
            listener: (context, authState) {
              if (authState is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(authState.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}
