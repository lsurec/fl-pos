// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  nuevoTema(ThemeModel tema) {
    Preferences.theme = tema.id;
    Preferences.themeName = tema.id.toString();
    print("${tema.id} id del tema y preferencia ${Preferences.theme}");
  }

  ThemeModel temaSistema(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;

    ThemeModel? systemTeme;

    if (isLightMode) {
      return ThemeModel(
        id: 1,
        descripcion: "Sistema (Claro)",
        theme: AppTheme.lightTheme,
      );
    }

    if (isDarkMode) {
      return ThemeModel(
        id: 0,
        descripcion: " Sistema (Oscuro)",
        theme: AppTheme.darkTheme,
      );
    }

    return systemTeme!;
  }

  List<ThemeModel> temasApp(BuildContext context) {
    return [
      temaSistema(context),
      ThemeModel(
        id: 1,
        descripcion: "Claro",
        theme: AppTheme.lightTheme,
      ),
      ThemeModel(
        id: 0,
        descripcion: "Oscuro",
        theme: AppTheme.darkTheme,
      )
    ];
  }
}
