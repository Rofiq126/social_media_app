import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const MyDrawerTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        icon,
        color: color.primary,
      ),
      title: Text(
        title,
        style: TextStyle(color: color.inversePrimary),
      ),
      onTap: onTap,
    );
  }
}
