import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return CupertinoButton(
        borderRadius: BorderRadius.circular(12),
        color: color.tertiary,
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: color.primary),
        ));
  }
}
