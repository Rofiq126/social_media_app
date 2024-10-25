import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: color.primary),
        fillColor: color.secondary,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.tertiary),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.primary),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
