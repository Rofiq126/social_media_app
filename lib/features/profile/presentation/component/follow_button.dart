//Follow Button

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFollowing;
  const FollowButton(
      {super.key, required this.onPressed, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return CupertinoButton(
        color: isFollowing ? color.primary : Colors.blue,
        onPressed: onPressed,
        child: Text(isFollowing ? 'Unfollow' : 'Follow'));
  }
}
