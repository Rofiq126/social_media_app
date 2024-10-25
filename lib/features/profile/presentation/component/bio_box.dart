import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(color: color.secondary),
      child: Text(text.isNotEmpty ? text : 'Empty bio..',
          style: TextStyle(color: color.inversePrimary)),
    );
  }
}
