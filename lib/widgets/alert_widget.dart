import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    Key? key,
    required this.title,
    required this.description,
    this.textOk,
    this.textCancel,
    required this.onOk,
    required this.onCancel,
  }) : super(key: key);

  final String title;
  final String description;
  final String? textOk;
  final String? textCancel;
  final Function onOk;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.colorTheme(
        Styles.background,
        Preferences.theme,
      ),
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: Text(
            textCancel ??
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'cancelar',
                ),
          ),
          onPressed: () => onCancel(),
        ),
        TextButton(
          child: Text(
            textOk ??
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'aceptar',
                ),
          ),
          onPressed: () => onOk(),
        ),
      ],
    );
  }
}
