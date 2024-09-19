import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
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
          style: StyleApp.normalBold,
        ),
      ],
    );
  }
}
