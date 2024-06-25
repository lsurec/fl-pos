import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';

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
        style: AppTheme.style(
          context,
          Styles.titleWhite,
          Preferences.idTheme,
        ),
      ),
    );
  }
}
