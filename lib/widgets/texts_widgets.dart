import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';

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
        style: AppTheme.normalStyle,
        children: [
          TextSpan(
            text: title,
            style: AppTheme.style(
              context,
              Styles.bold,
              Preferences.idTheme,
            ),
          ),
          TextSpan(
            text: text,
            style: AppTheme.style(
              context,
              Styles.normal,
              Preferences.idTheme,
            ),
          )
        ],
      ),
    );
  }
}
