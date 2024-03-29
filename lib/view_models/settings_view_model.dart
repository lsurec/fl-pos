import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';

class SettingsViewModel extends ChangeNotifier {
  navigatePrint(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(opcion: 1),
    );
  }
}
