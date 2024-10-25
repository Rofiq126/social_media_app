import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/presentation/component/follower_tile.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_states.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //search controller
  final searchController = TextEditingController();
  //final searchCubit
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() async {
    final query = searchController.text;
    await searchCubit.searchUser(query);
  }

  @override
  void initState() {
    //it will listen change in search controller and will performe search using onSearch changed method
    searchController.addListener(onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Search users..',
              hintStyle: TextStyle(color: color.primary)),
        ),
      ),
      //search result
      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          //loading
          if (state is SearchLoading) {
            return Center(child: CupertinoActivityIndicator());
          }
          //loaded
          else if (state is SearchLoaded) {
            return ListView.builder(
                itemCount: state.user.length,
                itemBuilder: (context, index) {
                  //get single item of user
                  final user = state.user[index];
                  return FollowerTile(user: user!);
                });
          }
          //error
          else if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
