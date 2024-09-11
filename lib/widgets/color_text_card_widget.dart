import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class ColorTextCardWidget extends StatelessWidget {
  const ColorTextCardWidget({
    super.key,
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      color: color,
      child: Text(
        text,
        style: StyleApp.titleWhite,
      ),
    );
  }
}
