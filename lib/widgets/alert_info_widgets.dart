import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

import '../themes/app_theme.dart';

class AlertInfoWidget extends StatelessWidget {
  const AlertInfoWidget({
    Key? key,
    required this.title,
    required this.description,
    this.textOk,
    required this.onOk,
  }) : super(key: key);

  final String title;
  final String description;
  final String? textOk;
  final Function onOk;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.color(
        Styles.background,
      ),
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: Text(
            textOk ??
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'aceptar',
                ),
            style: AppTheme.style(
              Styles.action,
            ),
          ),
          onPressed: () => onOk(),
        ),
      ],
    );
  }
}
