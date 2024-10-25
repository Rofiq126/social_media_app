import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/home/presentation/component/my_drawer_tile.dart';
import 'package:social_media_app/features/profile/presentation/page/profile_page.dart';
import 'package:social_media_app/features/search/presentation/pages/search_page.dart';
import 'package:social_media_app/features/settings/presentation/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: color.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  CupertinoIcons.person_fill,
                  size: 80,
                  color: color.primary,
                ),
              ),
              MyDrawerTile(
                  title: 'H O M E',
                  icon: CupertinoIcons.home,
                  onTap: () => Navigator.of(context).pop()),
              MyDrawerTile(
                  title: 'P R O F I L E',
                  icon: CupertinoIcons.person,
                  onTap: () {
                    //get current user id
                    final user = context.read<AuthCubit>().currentUser;
                    final id = user!.id;

                    //closing drawer
                    Navigator.of(context).pop();

                    //push to profile page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfilePage(uid: id)));
                  }),
              MyDrawerTile(
                  title: 'S E A R C H',
                  icon: CupertinoIcons.search,
                  onTap: () {
                    //closing drawer
                    Navigator.of(context).pop();
                    //push to search page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SearchPage()));
                  }),
              MyDrawerTile(
                  title: 'S E T T I N G',
                  icon: CupertinoIcons.settings,
                  onTap: () {
                    //close the drawer
                    Navigator.of(context).pop();
                    //push to settings page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SettingsPage()));
                  }),
              Spacer(),
              MyDrawerTile(
                  title: 'L O G O U T',
                  icon: CupertinoIcons.arrow_left_square,
                  onTap: () => context.read<AuthCubit>().logout()),
            ],
          ),
        ),
      ),
    );
  }
}
