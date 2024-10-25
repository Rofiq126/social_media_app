import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followCount;
  final VoidCallback onPressed;
  const ProfileStats(
      {super.key,
      required this.onPressed,
      required this.postCount,
      required this.followerCount,
      required this.followCount});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyleCount = TextStyle(fontSize: 20, color: color.inversePrimary);
    final textStyleText = TextStyle(color: color.primary);
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //post
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCount.toString(),
                  style: textStyleCount,
                ),
                Text(
                  'Posts',
                  style: textStyleText,
                )
              ],
            ),
          ),
          //followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: textStyleCount,
                ),
                Text(
                  'Followers',
                  style: textStyleText,
                )
              ],
            ),
          ),
          //following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followCount.toString(),
                  style: textStyleCount,
                ),
                Text(
                  'Following',
                  style: textStyleText,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
