import 'package:flutter/material.dart';

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
      backgroundColor: AppTheme.backroundColor,
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: Text(textOk ?? "Aceptar"),
          onPressed: () => onOk(),
        ),
      ],
    );
  }
}
