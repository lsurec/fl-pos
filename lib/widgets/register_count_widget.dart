import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class RegisterCountWidget extends StatelessWidget {
  const RegisterCountWidget({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.general,
            'registro',
          )} ($count)",
          style: AppTheme.style(
            context,
            Styles.bold,
          ),
        ),
      ],
    );
  }
}
