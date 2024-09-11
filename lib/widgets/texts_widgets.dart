import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class TextsWidget extends StatelessWidget {
  const TextsWidget({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: StyleApp.normal,
        children: [
          TextSpan(
            text: title,
            style: StyleApp.normalBold,
          ),
          TextSpan(
            text: text,
            style: StyleApp.normal,
          )
        ],
      ),
    );
  }
}
