import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/page/profile_page.dart';

class FollowerTile extends StatelessWidget {
  final ProfileUser user;
  const FollowerTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: color.secondary, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration:
              BoxDecoration(color: color.secondary, shape: BoxShape.circle),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: user.profileImageUrl,
            //loading
            placeholder: (context, url) => CupertinoActivityIndicator(),
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
        ),
        trailing: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ProfilePage(uid: user.id))),
            icon: Icon(
              CupertinoIcons.arrow_right_square,
              color: color.primary,
            )),
        title: Text(user.name),
        subtitle: Text(user.email),
      ),
    );
  }
}
