import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextFieldIos extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  const MyTextFieldIos(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return CupertinoTextField(
        controller: controller,
        obscureText: obsecureText,
        placeholder: hintText,
        placeholderStyle: TextStyle(color: color.primary),
        decoration: BoxDecoration(
            color: color.secondary, borderRadius: BorderRadius.circular(12)));
  }
}
