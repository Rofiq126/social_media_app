import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/presentation/component/follower_tile.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> follower;
  final List<String> following;
  const FollowerPage(
      {super.key, required this.follower, required this.following});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: ConstrainedScaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                text: 'Followers',
              ),
              Tab(
                text: 'Following',
              )
            ]),
          ),
          body: TabBarView(clipBehavior: Clip.hardEdge, children: [
            _buildUserList(follower, 'There is no followers', context),
            _buildUserList(following, 'There is no following', context),
          ]),
        ));
  }

  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              //get each uid
              final uid = uids[index];

              return FutureBuilder(
                  future: context.read<ProfileCubit>().getUserProfile(uid),
                  builder: (context, snapshot) {
                    //user loaded state
                    if (snapshot.hasData) {
                      final user = snapshot.data!;
                      return FollowerTile(user: user);
                    }
                    //loading state
                    else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                      //other state
                    } else {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    }
                  });
            });
  }
}
