import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';

class SettingsViewModel extends ChangeNotifier {
  navigatePrint(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(opcion: 1),
    );
  }

  navigateLang(BuildContext context) {
    AppLocalizations.cambiarIdioma = 1;
    notifyListeners();
    Navigator.pushNamed(
      context,
      AppRoutes.lang,
      // arguments: PrintDocSettingsModel(opcion: 1),
    );
  }

  navigateTheme(BuildContext context) {
    AppTheme.cambiarTema = 1;
    notifyListeners();
    Navigator.pushNamed(
      context,
      AppRoutes.theme,
      // arguments: PrintDocSettingsModel(opcion: 1),
    );
  }
}
