import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  navigatePrint(BuildContext context) {
    Navigator.pushNamed(
      context,
      "print",
      arguments: [
        1,
        0,
      ],
    );
  }
}
